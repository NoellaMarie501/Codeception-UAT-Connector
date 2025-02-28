<?php

declare(strict_types=1);


namespace Tests\Acceptance;

use Tests\Support\AcceptanceTester;

final class CashinCest
{
    public function _before(): void
    {
        
    }
    /**
     * Test health
     */
    public function checkHealthEndpoint(AcceptanceTester $I)
    {
        $I->wantTo('Ensure API health check works');
        $I->haveHttpHeader('x-api-version', 'v1');
        $I->haveHttpHeader('x-api-key', 'TESTKEY');
        $I->sendGET('/health');
        $I->seeResponseCodeIs(200);
        $I->seeResponseIsJson();
        $I->seeResponseContainsJson(["remote" => [
            "status" => "OK",
            "info" => "OK"
        ]]);
    }
}
