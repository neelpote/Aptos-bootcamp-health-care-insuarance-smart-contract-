// A simple smart contract for student health insurance.
// Students enroll themselves, and authorized providers can submit claims against their plan.
module MyModule::StudentHealthInsurance {

    use aptos_framework::signer;
    use std::error;

    // --- Error Constants ---
    const E_PLAN_NOT_FOUND: u64 = 1;
    const E_INSUFFICIENT_COVERAGE: u64 = 2;
    const E_PLAN_ALREADY_EXISTS: u64 = 3;

    /// Represents a student's insurance plan resource.
    /// This is stored directly under the student's account.
    struct Plan has key, store {
        total_coverage: u64,
        claimed_amount: u64,
    }

    /// A student enrolls and creates their own insurance plan resource.
    /// This is typically done once at the beginning of a semester.
    public entry fun enroll(student: &signer, coverage_amount: u64) {
        let student_addr = signer::address_of(student);
        // Ensure the student doesn't already have a plan to prevent duplicates.
        assert!(!exists<Plan>(student_addr), error::already_exists(E_PLAN_ALREADY_EXISTS));

        let insurance_plan = Plan {
            total_coverage: coverage_amount,
            claimed_amount: 0,
        };
        // Move the new plan resource to the student's account storage.
        move_to(student, insurance_plan);
    }

    /// An authorized healthcare provider submits a claim on behalf of a student.
    /// This function modifies the student's plan to reflect the new claim.
    public entry fun submit_claim(
        _provider: &signer, // Represents an authorized healthcare provider.
        student_address: address,
        claim_amount: u64
    ) acquires Plan {
        // In a real-world scenario, you would add logic here to verify that
        // the provider's address is on an approved list.

        // Ensure the student's insurance plan exists before proceeding.
        assert!(exists<Plan>(student_address), error::not_found(E_PLAN_NOT_FOUND));

        let plan = borrow_global_mut<Plan>(student_address);

        let remaining_coverage = plan.total_coverage - plan.claimed_amount;
        // Verify that the claim amount does not exceed the remaining coverage.
        assert!(claim_amount <= remaining_coverage, error::invalid_argument(E_INSUFFICIENT_COVERAGE));

        // Update the total amount claimed against the plan.
        plan.claimed_amount = plan.claimed_amount + claim_amount;
    }
}
