package com.company;

public class Error {
    // general error messages
    private static final String ERROR = "ERROR: ";
    private static final String TXND = "TRANSACTION DENIED.";

    // specific error messages
    private static final String NEGBAL = "THIS TRANSACTION RESULTS IN NEGATIVE BALANCE.";
    private static final String ACCTCONFL = "A DUPLICATE ACCOUNT NUMBER HAS BEEN CREATED.";


    public static void negBal() {
        System.out.println(ERROR + NEGBAL + ' ' + TXND);
    }

    public static void acctConfl() {
        System.out.println(ERROR + ACCTCONFL + ' ' + TXND);
    }

}
