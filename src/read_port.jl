## ------------------------------------------------------------
# # Modify these as needed
# portname = "/dev/cu.usbserial-1420"
# baudrate = 9600

function read_port(portname, baudrate; wt = 5)

    ## ------------------------------------------------------------
    # Snippet from examples/mwe.jl
    while true

        @info("Serial reading", 
            portname, 
            baudrate
        )
        println()

        try
            LibSerialPort.open(portname, baudrate; mode = SP_MODE_READ) do sp
                while true
                    line = readline(sp)
                    println(line)
                end
            end
        catch err

            (err isa InterruptException) && return
            @error err
            println()
            
        end

        sleep(wt)
    end
end

function read_port(argv::Vector = ARGS)
    port, rate = _parse_port_args(argv)
    read_port(port, rate)
end

function _parse_port_args(argv = ARGS)
    argset = ArgParse.ArgParseSettings()
    ArgParse.@add_arg_table! argset begin
        "--port", "-p"
            help="Serial port name"
            arg_type = String
            required=true
        "--rate", "-r"
            help="Root directory"
            arg_type = Int
            required=true
    end

    parsed_args = ArgParse.parse_args(argv, argset)
    port = parsed_args["port"]
    rate = parsed_args["rate"]
    
    return port, rate
end