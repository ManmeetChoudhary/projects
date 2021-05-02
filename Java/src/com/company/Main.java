package com.company;

public class Main {

    public static void main(String[] args) {
        BackEnd bankBackEnd = new BackEnd(args[0], args[1]);
        bankBackEnd.processData();
    }
}
