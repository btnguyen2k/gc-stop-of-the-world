#!/bin/sh

## Number of threads > Number of cores.
## Use -XX:MinHeapFreeRatio=5 -XX:MaxHeapFreeRatio=10 -XX:-ShrinkHeapInSteps

mvn clean assembly:assembly

CLASSNAME="com.github.btnguyen2k.gchistogram.App"
JAR_FILE="./target/gchistogram-1.0-jar-with-dependencies.jar"
JVM_OPS="-server -XX:+ExitOnOutOfMemoryError -XX:+CrashOnOutOfMemoryError -Xms16m -Xmx1234m -XX:MinHeapFreeRatio=5 -XX:MaxHeapFreeRatio=10 -XX:-ShrinkHeapInSteps"
NUM_THREADS=16
NUM_LOOPS=1000

GC_TYPE="G1"
JVM_OPS_EXTRA=""
echo "GC type: $GC_TYPE"
java -cp $JAR_FILE $JVM_OPS $JVM_OPS_EXTRA -XX:+Use${GC_TYPE}GC -DnumThreads=$NUM_THREADS -DnumLoops=$NUM_LOOPS -DsleepTime=10 $CLASSNAME
echo -n
java -cp $JAR_FILE $JVM_OPS $JVM_OPS_EXTRA -XX:+Use${GC_TYPE}GC -DnumThreads=$NUM_THREADS -DnumLoops=$NUM_LOOPS -DsleepTime=100 $CLASSNAME
echo -n
java -cp $JAR_FILE $JVM_OPS $JVM_OPS_EXTRA -XX:+Use${GC_TYPE}GC -DnumThreads=$NUM_THREADS -DnumLoops=$NUM_LOOPS -DsleepTime=100 $CLASSNAME
echo -n
echo -n

GC_TYPE="Parallel"
JVM_OPS_EXTRA=""
echo "GC type: $GC_TYPE"
java -cp $JAR_FILE $JVM_OPS $JVM_OPS_EXTRA -XX:+Use${GC_TYPE}GC -DnumThreads=$NUM_THREADS -DnumLoops=$NUM_LOOPS -DsleepTime=10 $CLASSNAME
echo -n
java -cp $JAR_FILE $JVM_OPS $JVM_OPS_EXTRA -XX:+Use${GC_TYPE}GC -DnumThreads=$NUM_THREADS -DnumLoops=$NUM_LOOPS -DsleepTime=100 $CLASSNAME
echo -n
java -cp $JAR_FILE $JVM_OPS $JVM_OPS_EXTRA -XX:+Use${GC_TYPE}GC -DnumThreads=$NUM_THREADS -DnumLoops=$NUM_LOOPS -DsleepTime=100 $CLASSNAME
echo -n

GC_TYPE="Serial"
JVM_OPS_EXTRA=""
echo "GC type: $GC_TYPE"
java -cp $JAR_FILE $JVM_OPS $JVM_OPS_EXTRA -XX:+Use${GC_TYPE}GC -DnumThreads=$NUM_THREADS -DnumLoops=$NUM_LOOPS -DsleepTime=10 $CLASSNAME
echo -n
java -cp $JAR_FILE $JVM_OPS $JVM_OPS_EXTRA -XX:+Use${GC_TYPE}GC -DnumThreads=$NUM_THREADS -DnumLoops=$NUM_LOOPS -DsleepTime=100 $CLASSNAME
echo -n
java -cp $JAR_FILE $JVM_OPS $JVM_OPS_EXTRA -XX:+Use${GC_TYPE}GC -DnumThreads=$NUM_THREADS -DnumLoops=$NUM_LOOPS -DsleepTime=100 $CLASSNAME
echo -n
echo -n

GC_TYPE="Shenandoah"
JVM_OPS_EXTRA=""
echo "GC type: $GC_TYPE"
java -cp $JAR_FILE $JVM_OPS $JVM_OPS_EXTRA -XX:+Use${GC_TYPE}GC -DnumThreads=$NUM_THREADS -DnumLoops=$NUM_LOOPS -DsleepTime=10 $CLASSNAME
echo -n
java -cp $JAR_FILE $JVM_OPS $JVM_OPS_EXTRA -XX:+Use${GC_TYPE}GC -DnumThreads=$NUM_THREADS -DnumLoops=$NUM_LOOPS -DsleepTime=100 $CLASSNAME
echo -n
java -cp $JAR_FILE $JVM_OPS $JVM_OPS_EXTRA -XX:+Use${GC_TYPE}GC -DnumThreads=$NUM_THREADS -DnumLoops=$NUM_LOOPS -DsleepTime=100 $CLASSNAME
echo -n
echo -n

GC_TYPE="Z"
JVM_OPS_EXTRA="-XX:+UnlockExperimentalVMOptions"
echo "GC type: $GC_TYPE"
java -cp $JAR_FILE $JVM_OPS $JVM_OPS_EXTRA -XX:+Use${GC_TYPE}GC -DnumThreads=$NUM_THREADS -DnumLoops=$NUM_LOOPS -DsleepTime=10 $CLASSNAME
echo -n
java -cp $JAR_FILE $JVM_OPS $JVM_OPS_EXTRA -XX:+Use${GC_TYPE}GC -DnumThreads=$NUM_THREADS -DnumLoops=$NUM_LOOPS -DsleepTime=100 $CLASSNAME
echo -n
java -cp $JAR_FILE $JVM_OPS $JVM_OPS_EXTRA -XX:+Use${GC_TYPE}GC -DnumThreads=$NUM_THREADS -DnumLoops=$NUM_LOOPS -DsleepTime=100 $CLASSNAME
echo -n
echo -n
