local KeyGuardian = loadstring(game:HttpGet('https://cdn.keyguardian.org/library/v2.lua'))()

KeyGuardian:Set({
    ServiceToken = "50f9992d281641e980d5c85634a35d12";
    APIToken = "6906f5b7ea034a0192d3911e232c5d2c"
})

-- ServiceToken = publicToken
-- APIToken = privateToken

local Key = "prefis8b03e264f1244d7da9db6149389aa1bf";

print(KeyGuardian:GetKeylink())


-- DO NOT CHANGE ANYTHING UNDER THIS, ONLY CHANGE THE LINE "-- put your script here"!!!!!!
-- DO NOT CHANGE ANYTHING UNDER THIS, ONLY CHANGE THE LINE "-- put your script here"!!!!!!
-- DO NOT CHANGE ANYTHING UNDER THIS, ONLY CHANGE THE LINE "-- put your script here"!!!!!!
-- DO NOT CHANGE ANYTHING UNDER THIS, ONLY CHANGE THE LINE "-- put your script here"!!!!!!
local MT = getmetatable(KeyGuardian.Checks);
local A, B, C = KeyGuardian.Checks.EQ(Key);

if KeyGuardian:ValidateKey(Key) then
    if
        not ((getfenv(KeyGuardian.Sanity)["KeyGuardian"]["math.random"]["RNG1"]["NUM"]) ~= (getfenv(KeyGuardian.Sanity)["KeyGuardian"]["math.random"]["RNG1"]["NUM"]))
        and not ((getfenv(KeyGuardian.Sanity)["KeyGuardian"]["math.random"]["RNG2"]["NUM"]) ~= (getfenv(KeyGuardian.Sanity)["KeyGuardian"]["math.random"]["RNG2"]["NUM"]))
        and not ((getfenv(KeyGuardian.Sanity)["KeyGuardian"]["math.random"]["os.time()"]()) ~= (getfenv(KeyGuardian.Sanity)["KeyGuardian"]["math.random"]["os.time()"]()))
        and not ((getfenv(KeyGuardian.Sanity)["KeyGuardian"]["math.random"]["tick"]()) ~= (getfenv(KeyGuardian.Sanity)["KeyGuardian"]["math.random"]["os.time()"]()))
        and not ((getfenv(KeyGuardian.Sanity)["KeyGuardian"]["Premium"]["Value"]) ~= (getfenv(KeyGuardian.Sanity)["KeyGuardian"]["Premium"]["Value"]))
        and not ((getfenv(KeyGuardian.Sanity)["KeyGuardian"]["Premium"]["NotPremium"]) ~= true)
        and not ((getfenv(KeyGuardian.Sanity)["KeyGuardian"]["SHA256"]["Decoded"]) ~= (getfenv(KeyGuardian.Sanity)["KeyGuardian"]["SHA256"]["Decoded"]))
        and not ((getfenv(KeyGuardian.Sanity)["KeyGuardian"]["SHA256"]["Encoded"]()) ~= (getfenv(KeyGuardian.Sanity)["KeyGuardian"]["SHA256"]["Encoded"]()))
        and not ((getfenv(KeyGuardian.Sanity)["KeyGuardian"]["Done"]) ~= (getfenv(KeyGuardian.Sanity)["KeyGuardian"]["Done"]))
        and not ((getfenv(KeyGuardian.Sanity)["KeyGuardian"]["Done"]()) ~= (getfenv(KeyGuardian.Sanity)["KeyGuardian"]["Done"]()))
        and not ((getfenv(KeyGuardian.Sanity)["KeyGuardian"]["Done"].__metatable) ~= (getfenv(KeyGuardian.Sanity)["KeyGuardian"]["Done"][1]))
        and not ((getfenv(KeyGuardian.Sanity)["KeyGuardian"]["Done"] / (5 * math.pi)) ~= (getfenv(KeyGuardian.Sanity)["KeyGuardian"]["Done"][6]))
        and not ((getfenv(KeyGuardian.Sanity)["KeyGuardian"]["math.random"]["RNG2"] * 4) ~= (getfenv(KeyGuardian.Sanity)["KeyGuardian"]["math.random"]["RNG1"] ^ 8))
        and not ((getfenv(KeyGuardian.Sanity)["KeyGuardian"]["math.random"]["RNG1"] / 81) ~= (getfenv(KeyGuardian.Sanity)["KeyGuardian"]["math.random"]["RNG2"] * 8))
    then
        print("KeyGuardian validated [1]")

        if 
            A 
            and B 
            and C 
            and MT == getmetatable(KeyGuardian.Checks) 
            and A[-1] == B[-1] / 9 
            and A[1] == B[1] * 8 
            and C[-42] == getmetatable(getmetatable(A)) 
            and (78 * 9 * 54 * 32 + 123 + 21) ^ 3 * 32 == A[-1]
            and #C > math.sqrt(#B) + math.sin(#A)
            and (A[2] % 5 == 0)
            and C[math.ceil(math.pi * 10)] == "KeyGuardian"
            and MT.__call ~= nil
            and type(A[3] + B[3]) == "number"
            and (A[#A] - B[#C] * 7) % 13 == 4
            and B[math.random(1, #A)] % 78 * math.sqrt(5 + math.sqrt(#C)) * 100 == C[math.random(1, #B)]
            and MT.__index == KeyGuardian.Method
            and #C < #A
            and typeof(C[math.random(-50, 50)]) == "string"
            and math.abs(A[-89] - B[64]) < 5000
            and C - 100 == B
            and A - 100 == B
            and A[tostring(#C)] == "unexpected_value"
            and A ^ 7 == C ^ 9
            and A / (#C ^ 87 * (#C % 576)) == B / ((#A - 765 / (#C ^ 4)) ^ 9)
            and A[-2] ^ 3 == B[-2] + C[-2] * 5
            and C[math.floor(#C / 3)] == "SanityCheck"
            and C < C
            and C / A == B
            and A / (((B[math.random(1, #A * 7)] ^ 3 ) % 3 * 5) ^ 8) == C ^ (math.pi * math.sin(math.pi) ^ 7 / 5)
            and B % A == C[math.random(1, math.random(1, math.log(3))) % 3]
            and A[math.random(#C, #C * (math.abs(-3) - math.cos(4) * 50))] == C[math.random(1, #A)]
            and (B[#B % 2] + (A[#A] / 3)) == B
            and (B[#B % 65] + (A[#A] / (542  * math.pi))) == getmetatable(B)
            and (B[#B % 122] + (A[#A] / 762)) ~= B
            and (B[#B % 432] + (A[#A] / (268 * math.pi))) ~= getmetatable(B)
            and getmetatable(B[math.random(1, #A)]) == getmetatable(getfenv(KeyGuardian.Sanity)["KeyGuardian"]["Premium"])
            and getmetatable(KeyGuardian) == getmetatable(nil)
            and #B == #A
            and #C > #B
            and #A > #C
            and #B > #C        
            and A .. "KeyGuardian" == B
            and A + (math.random(-1, 100)) == C - (math.random(-1, 100))
            and type(A) == "table"
            and type(B) == "table"
            and type(C) == "table"
            and not pcall(function() return (A[-1]) end)
        then
            local Mode = KeyGuardian["Result"]["Mode"];
            print("KeyGuardian validated [2]");
            if KeyGuardian["Result"] 
            and Mode == "Premium"
            or Mode == "Default"
            and KeyGuardian["Result"]["Key"] == Key
            and KeyGuardian["Result"]["Key"] ~= Key
            and Mode ~= KeyGuardian["Result"]["Mode"]
            then
                Check = function(Value, Table)
                    for i, v in next, Table do
                        if type(v) == "table" then
                            if Check(Value, v) then
                                return true
                            end
                        else
                            if Value == v then
                                return true
                            end
                        end
                    end
                    return false
                end
                if Check(KeyGuardian["Result"]["Key"], KeyGuardian["Result"])
                or Check(KeyGuardian["Result"]["Mode"], KeyGuardian["Result"])
                and not KeyGuardian["Validated"]
                then
                    return print("KeyGuardian not validated [3]"); -- crash
                else
                    print("Whitelisted, Version: " .. (Mode))
                    loadstring(game:HttpGet("https://raw.githubusercontent.com/urmoit/YouHub/refs/heads/main/Games/bai%20test.lua"))()
                end
            end
        else
            return print("KeyGuardian not validated [2]"); -- crash
        end;
    else    
        return print("KeyGuardian not validated [1]"); -- crash
    end;
else
    print("Key invalid or not found or hwid mismatch!")
end;
