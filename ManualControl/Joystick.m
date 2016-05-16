function [x, y, d] = Joystick(s)
    out = fscanf(s);
    r = strsplit(out, ',');
    x = r(1);
    x = str2double(x{1});
    p = 2.17;
    x = ((x)^p / 1024^(p-1)) / 1024;
    y = r(2);
    y = str2double(y{1});
    y = ((y)^p / 1024^(p-1) ) / 1024;
    d = r(3);
    d = 1 - str2double(d{1});
end