#
# curlInterface: Simple Web Access
#
# Implementations
#
InstallGlobalFunction("CurlRequest",
function(URL, type, out_string, opts...)
    local r, rnam;
    
    # Get options
    r := rec(verifyCert := true);
    if Length(opts) = 1 then
        if not IsRecord(opts[1]) then
            ErrorNoReturn("CurlRequest: <opts> must be a record");
        fi;
        for rnam in RecNames(opts[1]) do
            r.(rnam) := opts[1].(rnam);
        od;
    elif Length(opts) > 1 then
        ErrorNoReturn("CurlRequest: usage: requires 3 or 4 arguments, but ",
                      Length(opts) + 3, " were given");
    fi;
    
    # Check input
    if not IsString(URL) then
        ErrorNoReturn("CurlRequest: <URL> must be a string");
    elif not IsString(type) then
        ErrorNoReturn("CurlRequest: <type> must be a string");
    elif not IsString(out_string) then
        ErrorNoReturn("CurlRequest: <out_string> must be a string");
    elif r.verifyCert <> true and r.verifyCert <> false then
        ErrorNoReturn("CurlRequest: <opts>.verifyCert must be true or false");
    fi;

    return CURL_REQUEST(URL, type, out_string, r.verifyCert);
end);

InstallGlobalFunction( "DownloadURL",
function(URL, opts...)
    return CallFuncList(CurlRequest, Concatenation([URL, "GET", ""], opts));
end);

InstallGlobalFunction( "PostToURL",
function(URL, str, opts...)
    return CallFuncList(CurlRequest, Concatenation([URL, "POST", str], opts));
end);

InstallGlobalFunction( "DeleteURL",
function(URL, opts...)
    return CallFuncList(CurlRequest, Concatenation([URL, "DELETE", ""], opts));
end);
