package com.github.btnguyen2k.gchistogram;

import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import org.apache.commons.math3.stat.descriptive.DescriptiveStatistics;
import org.apache.commons.math3.stat.descriptive.SynchronizedDescriptiveStatistics;

import java.util.Random;

public final class App {
    static String format(double bytes, int digits) {
        String[] dictionary = { "bytes", "Kb", "Mb" };
        int index = 0;
        for (index = 0; index < dictionary.length-1; index++) {
            if (bytes < 1024) {
                break;
            }
            bytes = bytes / 1024;
        }
        return String.format("%." + digits + "f", bytes) + " " + dictionary[index];
    }

    static int parsePropsAsInt(String name, int defaultValue) {
        String value = System.getProperty(name, String.valueOf(defaultValue));
        try {
            int v = Integer.parseInt(value);
            return v > 0 ? v : defaultValue;
        } catch (Exception e) {
            return defaultValue;
        }
    }

    public static void main(String[] args) throws Exception {
        int numThreads = parsePropsAsInt("numThreads", 4);
        int numLoops = parsePropsAsInt("numLoops", 100);
        int blockSize = parsePropsAsInt("blockSize", 1024 * 1024);
        int sleepTime = parsePropsAsInt("sleepTime", 1000);
        Random seed = new Random(System.currentTimeMillis());

        System.out.println("Info " +new ToStringBuilder("Info", ToStringStyle.JSON_STYLE)
            .append("NumThreads", numThreads)
            .append("NumLoops", numLoops)
            .append("BlockSize", blockSize)
            .append("SleepTime", sleepTime)
            .append("MaxMemory", format(Runtime.getRuntime().maxMemory(), 1)));

        DescriptiveStatistics statsLatency = new SynchronizedDescriptiveStatistics();
        DescriptiveStatistics statsMemTotal = new SynchronizedDescriptiveStatistics();
        DescriptiveStatistics statsMemUsed = new SynchronizedDescriptiveStatistics();
        Thread[] threads = new Thread[numThreads];
        for (int i = 0; i < numThreads; i++) {
            threads[i] = new Thread(() -> {
                Random rand = new Random(seed.nextLong());
                for (int j = 0; j < numLoops; j++) {
                    long start = System.nanoTime();
                    byte[] block = new byte[blockSize];
                    block[0] = 0;
                    long memTotal = Runtime.getRuntime().totalMemory();
                    long memFree = Runtime.getRuntime().freeMemory();
                    long duration = System.nanoTime() - start;
                    statsLatency.addValue(duration);
                    statsMemTotal.addValue(memTotal);
                    statsMemUsed.addValue(memTotal - memFree);
                    block = null;
                    try {
                        Thread.sleep(rand.nextInt(sleepTime));
                    } catch (InterruptedException e) {
                    }
                }
            });
        }

        for ( int i = 0; i < 5; i++ ){
            System.gc();
            Thread.sleep(1000 + seed.nextInt(1000));
        }

        long start = System.currentTimeMillis();
        for (Thread t : threads) {
            t.start();
        }
        for (Thread t : threads) {
            t.join();
        }
        long duration = System.currentTimeMillis() - start;

        System.out.println("Latency : " + new ToStringBuilder("Latency", ToStringStyle.JSON_STYLE)
            .append("Min", statsLatency.getMin()/1E6)
            .append("Max", statsLatency.getMax()/1E6)
            .append("Avg", statsLatency.getMean()/1E6)
            .append("P99", statsLatency.getPercentile(99)/1E6)
            .append("P95", statsLatency.getPercentile(95)/1E6)
            .append("P90", statsLatency.getPercentile(90)/1E6));
        System.out.println("MemTotal: " + new ToStringBuilder("MemoryTotal", ToStringStyle.JSON_STYLE)
            .append("Min", format(statsMemTotal.getMin(), 1))
            .append("Max", format(statsMemTotal.getMax(), 1))
            .append("Avg", format(statsMemTotal.getMean(), 1))
            .append("P99", format(statsMemTotal.getPercentile(99), 1))
            .append("P95", format(statsMemTotal.getPercentile(95), 1))
            .append("P90", format(statsMemTotal.getPercentile(90), 1)));
        System.out.println("MemUsed : " + new ToStringBuilder("MemoryUsed", ToStringStyle.JSON_STYLE)
            .append("Min", format(statsMemUsed.getMin(), 1))
            .append("Max", format(statsMemUsed.getMax(), 1))
            .append("Avg", format(statsMemUsed.getMean(), 1))
            .append("P99", format(statsMemUsed.getPercentile(99), 1))
            .append("P95", format(statsMemUsed.getPercentile(95), 1))
            .append("P90", format(statsMemUsed.getPercentile(90), 1)));
        System.out.println("RunTime : " + new ToStringBuilder("RunTime", ToStringStyle.JSON_STYLE)
            .append("Duration", duration)
            .append("TotalNumLoops", numThreads*numLoops)
            .append("Speed", numThreads*numLoops*1000.0/duration));
    }
}
