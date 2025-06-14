# CMM Compiler (Code Generation)

## Overview

This project implements the code generation phase of a compiler for the CMM language. The generated code targets the **x86 assembly language**. It translates intermediate representations of CMM programs into target code, supporting further execution on the target platform.

This project contains only the code generation part of the compiler targeting the x86 platform. Lexical, syntax, and semantic analyzers (which are cross-platform) are available in [this repository](https://github.com/rsuffert/cmm-compiler).

## Requirements

- Java Runtime Environment (JRE) for compiling the CMM programs with `byaccj`;
- `make` for seamless use of the compiler;
- `gcc` for compiling the equivalent C programs to run the unit tests;
- An x86 machine to execute the generated code.

## Usage Instructions

1. **Clone the repository:**
    ```bash
    git clone https://github.com/rsuffert/cmm-compiler-codegen.git
    cd cmm-compiler-codegen
    ```

2. **Build the project:**
    ```bash
    make
    ```

3. **Use the `run.x` script to generate code for a `.cmm` file (samples are available in the `tests/` folder):**
    ```bash
    ./run.x <your-file>.cmm
    ```

4. **Execute the generated compiled binary (from the `bin` folder)**
    ```bash
    make-run bin/<your-file>
    ```

5. **(Optional) Clean all binary files:**
    ```bash
    make clean
    ```

## Running unit tests

1. **Run the tests:**
    ```bash
    make test
    ```

2. **Observe the output in the terminal.**
   
3. **(Optional) Clean all binary files:**
    ```bash
    make clean
    ```

**NOTICE:** You won't be able to run the unit tests on a non-x86 machine.