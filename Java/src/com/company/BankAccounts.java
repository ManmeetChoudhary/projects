package com.company;

import java.io.*;  // Import the File class
import java.util.*; // ArrayList
import java.math.BigDecimal; // to store balance

public class BankAccounts {

    private String ombaf; // Old Master Bank Accounts File

    private static final String NCBAF = "Current Bank Accounts File";
    private static final String NMBAF = "Master Bank Accounts File";

    private List<String[]> bankAccounts = new ArrayList<String[]>();


    public BankAccounts(String accountsFile) {
        this.ombaf = accountsFile;
    }

    public String getOmbaf() {
        return ombaf;
    }

    private List<String[]> getBankAccounts() {
        return bankAccounts;
    }

    private void sortByAcctNum() {
        Collections.sort(this.getBankAccounts(), new Comparator<String[]>() {
            @Override
            public int compare(String[] o1, String[] o2) {
                String num1 = o1[0];
                String num2 = o2[0];
                return num1.compareTo(num2); // sort by account number
            }
        });
    }

    //Will make this when transaction and bank account class is complete
    private void loadBankAccountsFile() {
        BufferedReader lineReader = null;

        try {
            lineReader = new BufferedReader(new FileReader(this.ombaf));
            String lineText = null;

            while ((lineText = lineReader.readLine()) != null) {
                String[] bAcct = lineText.split(" ");
                this.bankAccounts.add(bAcct);
            }

        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            try {
                if (lineReader != null) {
                    lineReader.close();
                }
            } catch (IOException ex) {
                ex.printStackTrace();
            }
        }


    }


    public void applyNewAccounts(List<String[]> accounts) {
        bankAccounts.addAll(accounts);
    }

    public void applyDeletedAccounts(List<String> accounts) {
        for (String num : accounts) {
            bankAccounts.removeIf(i -> i[0].contains(num));
        }
    }

    public void applyDisabledAccounts(List<String> accounts) {
        for (String num : accounts) {
            ListIterator<String[]> iterator = bankAccounts.listIterator();
            while (iterator.hasNext()) {
                String[] line = iterator.next();
                if (line[0].contains(num)) {
                    line[2] = "D";
                    iterator.set(line);
                }
            }
        }

    }


    // public void applyChangePlanAccounts(List<Integer> accounts){

    // }

    public void applyFnlBalCoeff(Map<String, BigDecimal> accounts) {

        for (Map.Entry m : accounts.entrySet()) {
            String number = m.getKey().toString();
            double change = Double.parseDouble(m.getValue().toString());
            ListIterator<String[]> iterator = this.getBankAccounts().listIterator();
            while (iterator.hasNext()) {
                String[] line = iterator.next();
                if (line[0].contains(number)) {
                    double balance = Double.parseDouble(line[3]);
                    balance = balance - change;
                    line[3] = Double.toString(balance);
                    iterator.set(line);
                }
            }
        }

    }

    public void applyTransactionHistory(Map<String, int[]> accounts) {
        for (Map.Entry m : accounts.entrySet()) {
            String number = m.getKey().toString();
            int[] array = accounts.get(number);
            int total = array[0] + array[1];

            System.out.println(m.getKey() + " " + total);

            ListIterator<String[]> iterator = this.getBankAccounts().listIterator();
            while (iterator.hasNext()) {
                String[] line = iterator.next();
                if (line[0].contains(number)) {
                    int trans = Integer.parseInt(line[4]);
                    trans = trans + total;
                    line[4] = Integer.toString(trans);
                    iterator.set(line);
                }
            }
        }

    }


    public void generateNMBAF() {
        try {
            File myObj = new File(this.NMBAF);
            if (myObj.createNewFile()) {
                System.out.println("File created: " + myObj.getName());
            } else {
                System.out.println("File already exists.");
            }
            FileWriter myWriter = new FileWriter(this.NMBAF);

            for (String[] account : bankAccounts) {
                String line = "";
                for (String word : account) {
                    line = line + word + " ";
                }
                myWriter.write(line);
                myWriter.write("\n");
            }
            myWriter.close();
        } catch (IOException e) {
            System.out.println("An error occurred.");
            e.printStackTrace();
        }

    }

    public void generateNCBAF() {
        BufferedWriter acctFile = null;
        try {
            File file = new File(this.NCBAF);
            if (!file.exists()) {
                file.createNewFile();
            }
            FileWriter fw = new FileWriter(file);
            acctFile = new BufferedWriter(fw);
            for (String[] bkAcct : this.getBankAccounts()) {
                String ba = bkAcct[0] + ' ' + bkAcct[1] + ' ' + bkAcct[2] + bkAcct[3] + bkAcct[4] + '\n';
                acctFile.write(ba);
            }
        } catch (IOException ioe) {
            ioe.printStackTrace();
        } finally {
            try {
                if (acctFile != null) {
                    acctFile.close();
                }
            } catch (Exception ex) {
                System.out.println("ERROR: ERROR IN CLOSING THE BUFFEREDWRITER " + ex);
            }
        }


    }


}
