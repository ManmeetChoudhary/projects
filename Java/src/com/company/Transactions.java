package com.company;

import java.util.*;
import java.io.*;
import java.math.BigDecimal;

public class Transactions {

    private String mbatf; // Merged Bank Account Transaction File
    private List<String[]> bankAccounts;
    private List<String[]> transactions = new ArrayList<String[]>();
    private Map<String, int[]> numOfTxn = new HashMap<String, int[]>();
    private Map<String, BigDecimal> fnlBalCoeff = new HashMap<String, BigDecimal>();

    // privileged transactions
    private List<String[]> newAccounts = new ArrayList<String[]>();
    private List<String> deletedAccounts = new ArrayList<String>();
    private List<String> disabledAccounts = new ArrayList<String>();
    private Map<String, String> changeplanedAccounts = new HashMap<String, String>();

    public Transactions(String transactionFile) {
        this.mbatf = transactionFile;
    }

    public Transactions(String transactionFile, List<String[]> bankAcct) {
        this.mbatf = transactionFile;
        this.bankAccounts = new ArrayList<>(bankAcct);
    }

    // getter methods

    private String getMbatf() {
        return mbatf;
    }

    public List<String[]> getBankAccounts() {
        return bankAccounts;
    }

    private List<String[]> getTransactions() {
        return transactions;
    }

    public Map<String, int[]> getNumOfTxn() {
        return numOfTxn;
    }

    public Map<String, BigDecimal> getFnlBalCoeff() {
        return fnlBalCoeff;
    }

    public List<String[]> getNewAccounts() {
        return newAccounts;
    }

    public List<String> getDeletedAccounts() {
        return deletedAccounts;
    }

    public List<String> getDisabledAccounts() {
        return disabledAccounts;
    }

    public Map<String, String> getChangeplanedAccounts() {
        return changeplanedAccounts;
    }

    // data processing

    /**
     * This method loads all lines (split by space) in the transaction file in the form of
     * {transaction code, account holder's name, account number, account balance, additional miscellaneous information}
     * and outputs them into transactions:List<String[]>.
     * This method also filters out all lines with account number, "00000",
     * since they are useless to the data processing.
     */
    private void loadTxn() {
        BufferedReader txnFile = null;
        try {
            String currentLine;
            txnFile = new BufferedReader(new FileReader(this.getMbatf()));
            while ((currentLine = txnFile.readLine()) != null) {
                String[] txn = currentLine.split(" "); // every line is split by spaces
                if (!txn[2].equals("00000")) { // filter out all lines containing "00000"
                    this.getTransactions().add(txn);
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            try {
                if (txnFile != null) {
                    txnFile.close();
                }
            } catch (IOException ex) {
                ex.printStackTrace();
            }
        }
//        for (String[] txn : this.getTransactions()) {
//            System.out.println(Arrays.toString(txn));
//        }
    }

    /**
     * This method sorts transactions:List<String[]> by account number in ascending order.
     */
    private void sortByAcctNum() {
        Collections.sort(this.getTransactions(), new Comparator<String[]>() {
            @Override
            public int compare(String[] o1, String[] o2) {
//                String name1 = o1[1];
//                String name2 = o2[1];
//                int nameCmp = name1.compareTo(name2); // first: sort by names
//                if (nameCmp != 0) {
//                    return nameCmp;
//                }

                String num1 = o1[2];
                String num2 = o2[2];
                return num1.compareTo(num2); // sort by account number
            }
        });
//        for (String[] txn : this.getTransactions()) {
//            System.out.println(Arrays.toString(txn));
//        }
    }

    /**
     * This method counts the occurrences of account numbers in transactions:List<string[]>
     * and outputs the result to numberOfTransactions:Map<String, int[]>
     * so that we can add up the transactions easily in BankEnd.
     * Assumption:
     * - transaction "create", "delete", "disable", "changeplan" DO NOT counts as 1 transaction
     * - to the corresponding account number
     */
    private void countFreq() {
        for (String[] txn : this.getTransactions()) {
            // TODO: need to consider 0.05
            int[] txnNum = this.getNumOfTxn().get(txn[2]);

            // If the account number is new, add to numOfTxn. If not, add 1 to number of transaction.
            // Excluding transaction create as a transaction to corresponding account number.
            // If you find this code hard to understand, you can look for the if statement right under this code.
            // The if statement is just another version of the code that does the same thing.
            boolean isPrvgTxn = (txn[0].equals("05") || txn[0].equals("06") ||
                    txn[0].equals("07") || txn[0].equals("08"));
            this.getNumOfTxn().put(
                    txn[2], // key: Account Number
                    (txnNum == null) ? // value: [transaction that cost $0.05, transaction that cost $0.1]
                            new int[]{0, this.isPrvgTxn(txn) ? 0 : 1} :
                            new int[]{0, this.isPrvgTxn(txn) ? txnNum[1] : txnNum[1] + 1} // false
            );
//            if (txnNum == null) { // If account number is new
//                // If the transaction is "create", "delete", "disable" and "changeplan", don't count as 1 transaction
//                if (txn[0].equals("05") || txn[0].equals("06") || txn[0].equals("07") || txn[0].equals("08")) {
//                    this.getNumOfTxn().put(txn[2], new int[]{0, 0});
//                } else { // If the transaction is non-privileged
//                    this.getNumOfTxn().put(txn[2], new int[]{0, 1});
//                }
//            } else {
//                if (txn[0].equals("05") || txn[0].equals("06") || txn[0].equals("07") || txn[0].equals("08")) {
//                    this.getNumOfTxn().put(txn[2], new int[]{0, txnNum[1] + 1});
//                } else { // If the transaction is non-privileged
//                    this.getNumOfTxn().put(txn[2], new int[]{0, 1});
//                }
//            }
        }

//        for (Map.Entry<String, int[]> kv : this.getNumOfTxn().entrySet()) {
//            System.out.println('"' + kv.getKey() + "\" : \"" + Arrays.toString(kv.getValue()) + '"');
//        }
    }

    /**
     * This method looks for all privileged transactions, and records them in
     * newAccounts:List<string[]>,
     * disabledAccounts:List<int> and
     * changeplanedAccounts:List<int> respectively.
     */
    private void loadPrvgOprn() {
        for (String acctNum : this.getNumOfTxn().keySet()) { // loop through every account number
            for (String[] txn : this.getTransactions()) { // loop through all transactions
                if (txn[2].equals(acctNum)) { // find all transactions of a account number

                    // PROCESS CREATE
                    if (txn[0].equals("05")) {
                        this.getNewAccounts().add(new String[]{txn[2], txn[1], "A", txn[3], "0000"});
                    }
                    // PROCESS DELETE
                    else if (txn[0].equals("06")) {
                        this.getDeletedAccounts().add(txn[2]);
                    }
                    // PROCESS DISABLE
                    else if (txn[0].equals("07")) {
                        this.getDisabledAccounts().add(txn[2]);
                    }
                    // PROCESS CHANGEPLAN
                    else if (txn[0].equals("08")) {
                        this.getChangeplanedAccounts().put(txn[2], txn[4]);
                    }
                }
            }
        }
//        for (String[] ba : this.getNewAccounts()) {
//            System.out.println(Arrays.toString(ba));
//        }
//        for (Map.Entry<String, String> kv : this.getChangeplanedAccounts().entrySet()) {
//            System.out.println('"' + kv.getKey() + "\" : \"" + kv.getValue() + '"');
//        }
    }

    /**
     * This method calculates the balance of transactions (withdrawal, transfer, paybill and deposit)
     * of each account number, and outputs the result to finalBalanceCoefficients:Map<String, double>.
     * Including the cost for each transaction.
     */
    private void calcBal() {
        for (String acctNum : this.getNumOfTxn().keySet()) { // loop through every account number
            BigDecimal balCoeff = BigDecimal.ZERO;

            // Calculate balance coefficient of the account number
            // after withdrawal, transfer, paybill and deposit
            for (String[] txn : this.getTransactions()) { // loop through all transactions
                if (txn[2].equals(acctNum)) { // find all transactions of a account number

                    // PROCESS WITHDRAWAL, TRANSFER, PAYBILL
                    if (txn[0].equals("01") || txn[0].equals("02") || txn[0].equals("03")) {
                        balCoeff = balCoeff.subtract(
                                BigDecimal.valueOf(
                                        Double.parseDouble(txn[3])
                                )
                        );
                    }
                    // PROCESS DEPOSIT
                    else if (txn[0].equals("04")) {
                        balCoeff = balCoeff.add(
                                BigDecimal.valueOf(
                                        Double.parseDouble(txn[3])
                                )
                        );
                    }
                }
            }
            // PROCESS TRANSACTION FEE
            BigDecimal fiveCTxnFee = BigDecimal.valueOf(this.getNumOfTxn().get(acctNum)[0]).multiply(BigDecimal.valueOf(0.1));
            BigDecimal tenCTxnFee = BigDecimal.valueOf(this.getNumOfTxn().get(acctNum)[1]).multiply(BigDecimal.valueOf(0.1));
            balCoeff = balCoeff.subtract(fiveCTxnFee);
            balCoeff = balCoeff.subtract(tenCTxnFee);
        }

    }


    // PROCESS TRANSACTIONS
    public void processTransactions() {
        this.loadTxn();
        this.sortByAcctNum();
        this.countFreq();
        this.loadPrvgOprn();
        this.calcBal();
    }

    private boolean isPrvgTxn(String[] txn) {
        return (txn[0].equals("05") || txn[0].equals("06") || txn[0].equals("07") || txn[0].equals("08"));
    }


}
