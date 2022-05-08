pragma circom 2.0.0;

include "../../node_modules/circomlib/circuits/comparators.circom";
include "../../node_modules/circomlib-matrix/circuits/matMul.circom";
include "../../node_modules/circomlib-matrix/circuits/matElemSum.circom"; // hint: you can use more than one templates in circomlib-matrix to help you
include "../../node_modules/circomlib/circuits/gates.circom";
template SystemOfEquations(n) { // n is the number of variables in the system of equations
    signal input x[n]; // this is the solution to the system of equations
    signal input A[n][n]; // this is the coefficient matrix
    signal input b[n]; // this are the constants in the system of equations
    signal output out; // 1 for correct solution, 0 for incorrect solution

    // [bonus] insert your code here
    // check Ax=b
    component mult = matMul(n,n,1);
    component field_check[n];
    component multi_gate = MultiAND(n);
    
    for(var i = 0 ; i < n ; i++){
        for(var j = 0 ; j < n ; j++){
            mult.a[i][j] <== A[i][j];
        }
    }

    for(var i = 0 ; i < n; i++){
        mult.b[i][0] <== x[i];
    }

    for(var i = 0 ; i < n; i ++){
        field_check[i] = IsEqual();
        field_check[i].in[0] <== mult.out[i][0];
        field_check[i].in[1] <== b[i];
        multi_gate.in[i] <== field_check[i].out;
    }
    out <== multi_gate.out;
}

component main {public [A, b]} = SystemOfEquations(3);