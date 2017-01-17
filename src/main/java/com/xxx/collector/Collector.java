package com.xxx.collector;

/**
 * Created by liyanguo on 17/1/16.
 */

public class Collector {
    public static void main(String args[]) {
        String log4j_config = System.getProperty("log4j.properties");
        System.out.println(log4j_config);

        while(true) {
            try {
                System.out.println("sleep 10...");
                Thread.sleep(10);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
    }
}
