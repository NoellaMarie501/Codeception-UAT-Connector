<?php 

declare(strict_types=1);


namespace Tests\Acceptance;

use Codeception\Template\Acceptance;
use Tests\Support\AcceptanceTester;


final class CashoutCest{

    public function _before(AcceptanceTester $I): void {
    }
    

    /**
     * Test successfully cashout
     */
    public function checkCashoutStatusFlow(AcceptanceTester $I){
     
        $I->haveHttpHeader('x-api-version', 'v1');
        $I->haveHttpHeader('Content-Type', 'application/json');
        $I->haveHttpHeader('x-api-key', 'TESTKEY');
        $I->sendPOST('/cashout/pay', [
            "service" => "MOMO_CASHOUT",
            "callbackUrl" => "http://localhost",
            "destination" => "075215268",
            "ptn" => "517855879",
            "amount" => "100",
            "agent" => [
                "agentId" => "075215268",
                "agentName" => "noella",
                "ccName" => "marie",
                "ccId" => "noe778"
            ]
        ]);
         // Check initial response
        $I->seeResponseCodeIs(201);
        $I->seeResponseIsJson();
        $I->seeResponseContainsJson([
            "status" => "QUEUED"
        ]);
        
        // Extract UUID from response
        $response = json_decode($I->grabResponse(), true);
        $uuid = $response['uuid'];
        
        // Send request to get status
        $I->sendGET("/payment/{$uuid}");
        $I->seeResponseCodeIs(200);
        $I->seeResponseIsJson();
        // $I->seeResponseContainsJson([
        //     "status" => "SUCCESS"
        // ]);
    }

    public function checkInvalidPhoneNumber(AcceptanceTester $I)
    {
        $I->wantTo('Ensure error is returned for invalid phone number');
        
        // Send cashout request with invalid phone number
        $I->haveHttpHeader('x-api-version', 'v1');
        $I->haveHttpHeader('Content-Type', 'application/json');
        $I->haveHttpHeader('x-api-key', 'TESTKEY');
        $I->sendPOST('/cashout/pay', [
            "service" => "MOMO_CASHOUT",
            "callbackUrl" => "http://localhost",
            "destination" => "1075215268",
            "ptn" => "517855879",
            "amount" => "100",
            "agent" => [
                "agentId" => "075215268",
                "agentName" => "noella",
                "ccName" => "marie",
                "ccId" => "noe778"
            ]
        ]);
        
        // Check error response
        $I->seeResponseCodeIs(400); 
        $I->seeResponseIsJson();
        $I->seeResponseContainsJson([
            "code" => 703100,
            "message" => "Valid destination is required",
            "devMessage" => "Valid destination is required"
        ]);
    }


    public function checkMissingApiKey(AcceptanceTester $I)
   {
    $I->wantTo('Ensure error is returned when API key is missing');
    
    // Send cashout request without API key
    $I->haveHttpHeader('x-api-version', 'v1');
    $I->haveHttpHeader('Content-Type', 'application/json');
    $I->sendPOST('/cashout/pay', [
        "service" => "MOMO_CASHOUT",
        "callbackUrl" => "http://localhost",
        "destination" => "075215268",
        "ptn" => "517855879",
        "amount" => "100",
        "agent" => [
            "agentId" => "075215268",
            "agentName" => "noella",
            "ccName" => "marie",
            "ccId" => "noe778"
        ]
    ]);
    
    // Check error response
    $I->seeResponseCodeIs(401); 
    $I->seeResponseIsJson();
    $I->seeResponseContainsJson([
        "code" => 702401,
        "message" => "The api key is invalid: "
    ]);
   }


   public function checkMissingApiVersion(AcceptanceTester $I)
   {
    $I->wantTo('Ensure error is returned when API version is missing');
    
    // Send cashout request without API version
    $I->haveHttpHeader('Content-Type', 'application/json');
    $I->haveHttpHeader('x-api-key', 'TESTKEY');
    $I->sendPOST('/cashout/pay', [
        "service" => "MOMO_CASHOUT",
        "callbackUrl" => "http://localhost",
        "destination" => "075215268",
        "ptn" => "517855879",
        "amount" => "100",
        "agent" => [
            "agentId" => "075215268",
            "agentName" => "noella",
            "ccName" => "marie",
            "ccId" => "noe778"
        ]
    ]);
    
    // Check error response
    $I->seeResponseCodeIs(401); 
    $I->seeResponseContainsJson([
        "code" => 702010,
        "message" => "the specified version is not supported by this api: "
    ]);
   }

   public function checkInvalidAmount(AcceptanceTester $I)
   {
    $I->wantTo('Ensure error is returned for invalid amount');

    // Test with amount below minimum
    $I->haveHttpHeader('x-api-version', 'v1');
    $I->haveHttpHeader('Content-Type', 'application/json');
    $I->haveHttpHeader('x-api-key', 'TESTKEY');
    $I->sendPOST('/cashout/pay', [
        "service" => "MOMO_CASHOUT",
        "callbackUrl" => "http://localhost",
        "destination" => "075215268",
        "ptn" => "517855879",
        "amount" => "0", // Invalid amount
        "agent" => [
            "agentId" => "075215268",
            "agentName" => "noella",
            "ccName" => "marie",
            "ccId" => "noe778"
        ]
    ]);

    // Check error response for amount below minimum
    $I->seeResponseCodeIs(400); 
    $I->seeResponseIsJson();
    $I->seeResponseContainsJson([
        "code" => 703100,
        "message" => "amount must be greater than 0,Amount must be at least 1 and at most 500000",
        "devMessage" => "amount must be greater than 0,Amount must be at least 1 and at most 500000"
    ]);

    // Test with amount above maximum
    $I->sendPOST('/cashout/pay', [
        "service" => "MOMO_CASHOUT",
        "callbackUrl" => "http://localhost",
        "destination" => "075215268",
        "ptn" => "517855879",
        "amount" => "500001", // Invalid amount
        "agent" => [
            "agentId" => "075215268",
            "agentName" => "noella",
            "ccName" => "marie",
            "ccId" => "noe778"
        ]
    ]);

    // Check error response for amount above maximum
    $I->seeResponseCodeIs(400); 
    $I->seeResponseIsJson();
    $I->seeResponseContainsJson([
        "code" => 703100,
        "message" => 'Amount must be at least 1 and at most 500000',
        "devMessage" => 'Amount must be at least 1 and at most 500000'
    ]);
  }
  public function checkMissingPTN(AcceptanceTester $I)
{
    $I->wantTo('Ensure error is returned when PTN is missing');

    // Send cashout request without PTN
    $I->haveHttpHeader('x-api-version', 'v1');
    $I->haveHttpHeader('Content-Type', 'application/json');
    $I->haveHttpHeader('x-api-key', 'TESTKEY');
    $I->sendPOST('/cashout/pay', [
        "service" => "MOMO_CASHOUT",
        "callbackUrl" => "http://localhost",
        "destination" => "075215268",
        "amount" => "100",
        "agent" => [
            "agentId" => "075215268",
            "agentName" => "noella",
            "ccName" => "marie",
            "ccId" => "noe778"
        ]
        // Missing PTN
    ]);

    // Check error response
    $I->seeResponseCodeIs(400); 
    $I->seeResponseIsJson();
    $I->seeResponseContainsJson([
        "code" => 703100,
        "message" => "ptn is required",
        "devMessage" => "ptn is required"
    ]);
}
public function checkDuplicatePTN(AcceptanceTester $I)
{
    $I->wantTo('Ensure error is returned when PTN already exists');
   // Insert a record with an existing PTN into the database
    $I->haveInDatabase('transaction', [
        'ptn' => '507855879', // Existing PTN 
        'service' => 'MOMO_CASHOUT',
        'amount' => '100',
        'uuid' => '0b262253-9d28-4990-b4c8-449ce7c991a6',
        'destination' => '075215268',
        'callback_url' => 'http://localhost',
        'callback_attempt' => '0',
        'created_at'=> '2025-02-27',
        'status'=>'200',
        'type'=> 'MOMO_CASHOUT',
        "agent_id" => "075215268",
        "agent_name" => "noella",
        'collector_company_id'=>'noe778',
        'collector_company_name'=>'marie'
    ]);
    // Send cashout request with an existing PTN
    $I->haveHttpHeader('x-api-version', 'v1');
    $I->haveHttpHeader('Content-Type', 'application/json');
    $I->haveHttpHeader('x-api-key', 'TESTKEY');
    $I->sendPOST('/cashout/pay', [
        "service" => "MOMO_CASHOUT",
        "callbackUrl" => "http://localhost",
        "destination" => "075215268",
        "ptn" => "507855879", // Existing PTN 
        "amount" => "100",
        "agent" => [
            "agentId" => "075215268",
            "agentName" => "noella",
            "ccName" => "marie",
            "ccId" => "noe778"
        ]
    ]);

    // Check error response
    $I->seeResponseCodeIs(500); 
    $I->seeResponseIsJson();
    $I->seeResponseContainsJson([
        "code" => 705000,
        "message" => "Unexpected error during payment",
        "devMessage" => "A record with the same PTN already exists"
    ]);
}
public function checkMissingCallbackUrl(AcceptanceTester $I)
{
    $I->wantTo('Ensure error is returned when callback URL is missing');

    // Send cashin request without callback URL
    $I->haveHttpHeader('x-api-version', 'v1');
    $I->haveHttpHeader('Content-Type', 'application/json');
    $I->haveHttpHeader('x-api-key', 'TESTKEY');
    $I->sendPOST('/cashout/pay', [
        "service" => "MOMO_CASHOUT",
        "destination" => "075215268",
         // Missing callback URL
        "ptn" => "517855879",
        "amount" => "100",
        "agent" => [
            "agentId" => "075215268",
            "agentName" => "noella",
            "ccName" => "marie",
            "ccId" => "noe778"
        ]
    
    ]);

    // Check error response
    $I->seeResponseCodeIs(400); 
    $I->seeResponseIsJson();
    $I->seeResponseContainsJson([
        "code" => 703100,
        "message" => "callbackUrl is required,Valid callbackUrl is required",
        "devMessage" => "callbackUrl is required,Valid callbackUrl is required"
    ]);
}

}

?>