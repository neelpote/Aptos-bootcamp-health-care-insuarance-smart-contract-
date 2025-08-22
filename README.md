Aptos Student Health Insurance Smart Contract

A simple, proof-of-concept smart contract built on the Aptos blockchain to manage student health insurance plans. This contract allows students to create an insurance plan and enables authorized healthcare providers to submit claims against it.
📜 Overview

The core idea is to create a decentralized and transparent system for handling student insurance. Each student's insurance plan is a resource stored directly under their own account, giving them full ownership and control.
✨ Features

    Student Enrollment: Students can call the enroll function to create their own insurance plan with a specified coverage amount.

    Claim Submission: Authorized entities (e.g., hospitals, clinics) can call the submit_claim function to file a claim against a student's plan.

    On-Chain Verification: The contract includes checks to prevent duplicate plans and to ensure claims do not exceed the available coverage.

🚀 How It Works

The smart contract contains one primary resource and two main functions:
Plan Struct

This resource holds the state of a student's insurance plan.

    total_coverage: The maximum amount that can be claimed.

    claimed_amount: The cumulative amount that has already been claimed.

enroll(student: &signer, coverage_amount: u64)

    Purpose: Creates and initializes an insurance Plan for a student.

    Usage: A student signs and submits this transaction to create their plan for the semester.

    Checks: It ensures that the student does not already have an existing plan.

submit_claim(_provider: &signer, student_address: address, claim_amount: u64)

    Purpose: Allows a provider to make a claim against a student's insurance.

    Usage: A healthcare provider signs and submits this transaction after providing a service to the student.

    Checks:

        Verifies that the student has an active insurance plan.

        Ensures the claim_amount does not exceed the remaining coverage.

🛠️ Getting Started
Prerequisites

    Aptos CLI installed.

    A funded Aptos account for deployment and testing.

Deployment

    Update the Address: Change 0xYOUR_ADDRESS in the module declaration to your Aptos account address.

    Compile the Module:

    aptos move compile --named-addresses StudentHealthInsurance=<YOUR_ADDRESS>

    Publish the Module:

    aptos move publish --named-addresses StudentHealthInsurance=<YOUR_ADDRESS>

🚨 Error Handling

The contract will fail with one of the following error codes if conditions are not met:

    E_PLAN_ALREADY_EXISTS (3): Thrown if a student tries to enroll when they already have a Plan.

    E_PLAN_NOT_FOUND (1): Thrown during submit_claim if the specified student_address does not have a Plan.

    E_INSUFFICIENT_COVERAGE (2): Thrown if a claim_amount is greater than the remaining coverage in the Plan.
