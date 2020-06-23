package com.usa.ri.gov.ies.co.batches.main;

import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.usa.ri.gov.ies.co.batches.model.CoBatchRunDetailsModel;
import com.usa.ri.gov.ies.co.batches.model.CoBatchSummaryModel;
import com.usa.ri.gov.ies.co.batches.model.CoTriggersModel;
import com.usa.ri.gov.ies.co.batches.service.CoBatchService;
import com.usa.ri.gov.ies.ed.model.EligibilityDetailModel;
import com.usa.ri.gov.ies.ed.service.EligibilityDetailServiceImpl;

@Service("coPlanStmtGenDly")
public class CoPlanStmtGenDlyBatch {

	public static void main(String[] args) {
		CoPlanStmtGenDlyBatch batch = new CoPlanStmtGenDlyBatch();
		batch.init();
	}

	public void init() {
		Integer runSeq = preProcess();
		start();
		postProcess(runSeq);
	}

	@Autowired
	private CoBatchService coBatchService;

	@Autowired
	private EligibilityDetailServiceImpl edDetailService;

	private static final String BATCH_ID = "CO-PLN-STMT-DLY";
	private static Long SUCCESSFUL_TRG_CNT = 0L;
	private static Long FAILURE_TRG_CNT = 0L;

	public Integer preProcess() {
		// insert batch run details with ST status
		CoBatchRunDetailsModel model = new CoBatchRunDetailsModel();
		model.setBatchName(BATCH_ID);
		model.setBatchRunStatus("ST");
		model.setStartDate(new Date());

		// inserting Run details
		model = coBatchService.insertBatchRunDetails(model);

		return model.getRunSeq();
	}

	public void start() {

		// read all pending triggers
		List<CoTriggersModel> triggers = coBatchService.findPendingTriggers();

		// call process method for eachTrigger
		for (CoTriggersModel trigger : triggers) {
			process(trigger);
		}
	}

	public void process(CoTriggersModel trgModel) {
		// using trigger case num read eligibility data
		Long caseNum = trgModel.getCaseNum();

		EligibilityDetailModel edModel = edDetailService.findByCaseNum(caseNum);

		// generate pdf based on plan_status

		String planStatus = edModel.getPlanStatus();

		if (planStatus.equalsIgnoreCase("AP")) {
			// generate approved plan pdf
		} else if (planStatus.equalsIgnoreCase("DN")) {
			// generate denied plan pdf
		}

		// send pdf to customer email
		// store pdf in db
		// increment trigger count variable (success|failure)
		// if success update trigger as completed

	}

	public void postProcess(Integer runSeq) {
		// update batch run status as EN with EndDate
		CoBatchRunDetailsModel model = coBatchService.findByRunSeqNum(runSeq);
		model.setBatchRunStatus("EN");
		model.setEndDate(new Date());
		coBatchService.updateBatchRunDetails(model);

		// save Batch Summary
		CoBatchSummaryModel summaryModel = new CoBatchSummaryModel();
		summaryModel.setBatchName(BATCH_ID);
		summaryModel.setSuccessTriggerCount(SUCCESSFUL_TRG_CNT);
		summaryModel.setFailureTriggerCount(FAILURE_TRG_CNT);
		summaryModel.setTotalTriggerProcessed(SUCCESSFUL_TRG_CNT + FAILURE_TRG_CNT);
		coBatchService.saveBatchSummary(summaryModel);

	}

}
