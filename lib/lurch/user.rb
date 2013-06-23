module Lurch
  class User < Sequel::Model

    set_primary_key :email
    unrestrict_primary_key

  end
end
