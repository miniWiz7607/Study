function [n_errors, n_bits] = calculate_ber(tx_bits, rx_bits)
% calculate_ber - Calculates the number of bit errors.
%
% Syntax: [n_errors, n_bits] = calculate_ber(tx_bits, rx_bits)
%
% Inputs:
%    tx_bits - The transmitted bit stream (column vector).
%    rx_bits - The received bit stream (column vector).
%
% Outputs:
%    n_errors - The total number of bit errors.
%    n_bits   - The total number of bits transmitted.

% Ensure both inputs are column vectors for comparison
tx_bits = tx_bits(:);
rx_bits = rx_bits(:);

% Check for length mismatch, which indicates a serious problem
if length(tx_bits) ~= length(rx_bits)
    error('Transmitted and received bit streams have different lengths.');
end

% Total number of bits
n_bits = length(tx_bits);

% Calculate the number of errors by finding where the bits differ
n_errors = sum(tx_bits ~= rx_bits);

end
