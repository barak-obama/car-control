function [x, y, d] = Joystick(s)
    out = fscanf(s);
    r = strsplit(out, ',');
    while length(r)<3
        out = fscanf(s);
        r = strsplit(out, ',');
    end
    x = r(1);
    x = str2double(x{1});
    x = (x - 503) / 520;
    y = r(2);
    y = str2double(y{1});
    y = (y  - 510 ) / 515;
    d = r(3);
    d = 1 - str2double(d{1});
end