class JsonWebToken
  class << self
    def encode(payload)
      JWT.encode payload, Devise.secret_key, 'HS256', typ: 'JWT'
    end

    def decode(token)
      JWT.decode(token, Devise.secret_key, true, algorithm: 'HS256', verify_jti: true).first
    end
  end
end
