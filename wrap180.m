function [wrappedDegrees] = wrap180(unwrappedDegrees);

	wrappedDegrees=atan2(sind(unwrappedDegrees),cosd(unwrappedDegrees))*180/pi;
end
