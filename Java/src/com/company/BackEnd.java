package com.company;

public class BackEnd {


	private final String mbatf; // Merged Bank Account Transaction File
	private final String ombaf; // Old Master Bank Accounts File

	public BackEnd(String transactionFile, String accountsFile){
		this.mbatf = transactionFile;
		this.ombaf = accountsFile;
	}

	public String getMbatf() {
		return mbatf;
	}

	public String getOmbaf() {
		return ombaf;
	}

	public void processData() {
        Transactions txns = new Transactions(this.getMbatf());
		txns.processTransactions();
	}

	//Will make this when transaction and bank account class is complete
//	static void processBackEnd() {
//		txn = Transaction(mbatf);
//		ba = BankAcounts(ombaf);
//
//		txn.processTransactions();
//		ba.applyDeletedAccounts();
//	}

}
