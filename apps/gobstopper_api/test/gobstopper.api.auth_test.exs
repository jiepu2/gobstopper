defmodule Gobstopper.API.AuthTest do
    use Gobstopper.Service.Case

    alias Gobstopper.API.Auth

    test "invalid token logout" do
        assert :ok == Auth.logout(nil)
    end

    test "verify invalid token" do
        assert nil == Auth.verify(nil)
    end

    test "valid token logout and verify" do
        { :ok, token } = Auth.Email.register("foo@bar", "secret")
        assert nil != Auth.verify(token)
        assert :ok == Auth.logout(token)
        :timer.sleep(100)
        assert nil == Auth.verify(token)
    end

    test "valid token refresh and verify" do
        { :ok, token } = Auth.Email.register("foo@bar", "secret")
        identity = Auth.verify(token)
        assert { :ok, token2 } = Auth.refresh(token)
        assert nil == Auth.verify(token)
        assert identity == Auth.verify(token2)
    end
end
