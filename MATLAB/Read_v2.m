clear all
close all

% Create a serial object
s = serial('COM5');

% Set the baud rate, data type, stop bits, parity, and flow control
s.BaudRate = 115200;
s.DataBits = 8;
s.StopBits = 1;
s.Parity = 'none';
s.FlowControl = 'none';

% Open the serial connection
fopen(s);

% Pre-allocate array for data
num_samples = 2048;
data = zeros(num_samples, 1, 'uint32');

% Loop to read data from the serial port
for i = 1 : ceil(num_samples/128)
    if(i == 1)
        % Send command to start data acquisition
        fwrite(s, 1, 'uint8');
        % Wait for data to be available
        %pause(0.002 + 128/500000); % add extra time for data to be transmitted
        pause(0.1)
        flag = fread(s, 1, 'uint8');
        pause(0.03)
        % Read first block of data
        if(s.BytesAvailable > 0)
            data((i-1)*128+1:i*128) = fread(s, 128, 'uint32');
        end
        %pause(0.002 + 128/500000); % add extra time for data to be transmitted
        pause(0.03) 
    else        
        % Read next block of data
        if(s.BytesAvailable > 0)
            data((i-1)*128+1:i*128) = fread(s, 128, 'uint32');
        end
        %pause(0.002 + 128/500000); % add extra time for data to be transmitted
        pause(0.03)

    end
end

% Close the serial connection
fclose(s);

% Plot the data
plot(data);
