function [lat,long] = wgs2gcj(lat,long);

a = 6378245.0;
ee = 0.00669342162296594323;
if(outOfChina(lat,long)),return; end;

 dLat = transformLat(lat,long);
 dLon = transformLong(lat,long);
 radLat = lat / 180.0 * pi;
 magic = sin(radLat);
 magic = 1 - ee * magic.^2;
 sqrtMagic = magic.^(.5);
 dLat = (dLat * 180.0)./((a * (1 - ee))./(magic.*sqrtMagic)*pi);
 dLon = (dLon * 180.0)./(a./sqrtMagic.*cos(radLat)*pi);
 lat = lat + dLat;
 long = long + dLon;

end

function result = outOfChina(lat,long)
    result = false;
    if any(long < 72.004 | long > 137.8347) result = true; end
    if any(lat < 0.8293 | lat > 55.8271) result = true; end
end

function deltaLat = transformLat(lat,long)
    x = long -105;
    y = lat -35;
    deltaLat = -100+ 2*x + 3*y + 0.2*y.^2 + 0.1.*x.*y + 0.2*sqrt(abs(x))+...
    (2/3)*((20*sin(6*x*pi)+20*sin(2*x*pi))+...
    (20*sin(pi*y) + 40*sin(pi/3*y)) +...
    (160*sin(y./12.*pi) + 320*sin(y.*pi./30)));
end


function deltaLong = transformLong(lat,long)
    x = long -105;
    y = lat -35;
    deltaLong = 300 + x + 2*y + 0.1*x.^2 + 0.1*x.*y + 0.1.*sqrt(abs(x))+...
    2/3*((20*sin(6*pi*x) + 20*sin(2*pi*x))+ ...
    (20*sin(pi*x) + 40*sin(pi/3*x))+ ...
    (150*sin(pi/12*x) + 300*sin(pi/30*x)));

end