

function parse_response(resp)
    return (
        HTTP.payload(resp, String) |> JSON.parse
    )
end

function header_maker(type="Bearer", spotcred=spotcred)
    if type == "Bearer"
        return ["Authorization" => "Bearer $(spotcred.access_token)"]
    elseif type == "Basic"
        return ["Authorization" => "Basic $(spotcred.encoded_credentials)"]
    else 
        error("Return type not recognized")
    end
end