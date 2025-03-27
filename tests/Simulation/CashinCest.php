<?php

declare(strict_types=1);


namespace Tests\Simulation;

use Codeception\Template\Simulation;
use Tests\Support\SimulationTester;

final class CashinCest
{
    public function _before( SimulationTester $I): void {
    }
    
    /**
     * Test cashin
     */
    public function checkCashinStatusFlow( SimulationTester $I)
    {
        $I->wantTo('Ensure cashin request is queued and then successful');
        
        // Send cashin request to fdigitech connector
        $I->haveHttpHeader('x-api-version', 'v1');
        $I->haveHttpHeader('Content-Type', 'application/json');
        $I->haveHttpHeader('x-api-key', 'TESTKEY');
        $I->sendPOST('/cashin/pay', [
            "service" => "MOMO_CASHIN",
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
        
    
        
        // Send request to get status
        $I->sendGET("/payment/");
        $I->seeResponseCodeIs(200);
        $I->seeResponseIsJson();
        $I->seeResponseContainsJson([
             "status" => "SUCCESS"
         ]);
    }
}



?>