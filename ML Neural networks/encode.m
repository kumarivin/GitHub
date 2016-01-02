function encode(str)
    if strfind(str,'down')
        first=1
    elseif strfind(str,'hold')
        first=2    
    elseif strfind(str,'stop')
        first=3
    elseif strfind(str,'up')
        first=4
end       