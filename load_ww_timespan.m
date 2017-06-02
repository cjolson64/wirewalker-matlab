function ww_data = load_ww_timespan(start_time, end_time)

    url = 'http://gdc-kepler.ucsd.edu/thredds/dodsC/WireWalker';
    
    % convert the timestamps to unix time (seconds since 01-01-1970)
    start_time_unix = int32(floor(86400 * (datenum(start_time) - datenum('01-Jan-1970'))));
    end_time_unix = int32(floor(86400 * (datenum(end_time) - datenum('01-Jan-1970'))));
    
    time = ncread(url, 'Time');
    
    % Filter the time array on start/end
    T = find(time >= start_time_unix & time <= end_time_unix);
    
    fieldnames = {};
    ww_data = struct();
    
    % Grab the info to find list of variables
    info = ncinfo(url);
    
    % Loop through the Variable names, grab them from thredds, and load
    % them into the ww_data struct
    for index = 1:length(info.Variables)
        fieldname = info.Variables(index).Name;
        ww_data.(fieldname) = ncread(url, fieldname, T(1), length(T));
    end

end
