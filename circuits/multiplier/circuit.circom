pragma circom 2.0.0;


template GivenCircuit () {  

   signal input a;
   signal input b;
   signal X;
   signal Y;
   signal output Q;

   // Component gates used to create custom curcuit
   component andGate = AND();
   component notGate = NOT();
   component orGate = OR();

   // Circuit Logic
   andGate.a <== a;
   andGate.b <== b;
   X <== andGate.out;

   notGate.in <== b;
   Y <== notGate.out;

   orGate.a <== X;
   orGate.b <== Y;
   Q <== orGate.out;

}

template AND() {
    signal input a;
    signal input b;
    signal output out;

    out <== a*b;
}

template NOT() {
    signal input in;
    signal output out;

    out <== 1 + in - 2*in;
}

template OR() {
    signal input a;
    signal input b;
    signal output out;

    out <== a + b - a*b;
}

component main = GivenCircuit();
