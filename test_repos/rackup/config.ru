app = proc do |env|
    [ 200, {'Content-Type' => 'text/plain'}, ["Test docker cartridge"] ]
end

run app
