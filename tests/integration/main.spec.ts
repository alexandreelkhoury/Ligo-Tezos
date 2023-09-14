import "mocha";
import dotenv from "dotenv";
import * as assert from "assert";

dotenv.config();

describe("Main ", () => {
    let x = "";

    before (async () => {
        x = "Hello";
    });

    it("should say hello", async () => {
        assert.equal(x, "Hello");
    });

    after (async () => {
        x = "";
    })});