function [tx_signal, tx_bits] = ofdm_transmitter(n_fft, n_cp, n_carriers, modulation_order, n_symbols)
% ofdm_transmitter - Generates an OFDM signal.
%
% Syntax: [tx_signal, tx_bits] = ofdm_transmitter(n_fft, n_cp, n_carriers, modulation_order, n_symbols)
%
% Inputs:
%    n_fft        - FFT size.
%    n_cp         - Cyclic prefix length.
%    n_carriers   - Number of data subcarriers.
%    modulation_order - Modulation order (e.g., 4 for QPSK).
%    n_symbols    - Number of OFDM symbols to generate.
%
% Outputs:
%    tx_signal    - The generated complex time-domain OFDM signal.
%    tx_bits      - The original transmitted bits.

bits_per_symbol = log2(modulation_order);
total_bits = n_carriers * bits_per_symbol * n_symbols;

% 1. Generate random bits
tx_bits = randi([0 1], total_bits, 1);

% 2. Modulate bits to symbols (QPSK)
% Reshape bits for modulation
tx_bits_reshaped = reshape(tx_bits, bits_per_symbol, [])';
% Convert binary to integer symbols
int_symbols = bi2de(tx_bits_reshaped, 'left-msb');
% Apply QPSK modulation
modulated_symbols = qammod(int_symbols, modulation_order);

% Reshape symbols into a matrix for OFDM frame construction
symbols_matrix = reshape(modulated_symbols, n_carriers, n_symbols);

% Initialize the OFDM frame matrix
ofdm_frame = zeros(n_fft, n_symbols);

% 3. Map symbols to subcarriers (Simplified Method)
% We map to the first N carriers, leaving DC (carrier 1) empty.
ofdm_frame(2:(n_carriers + 1), :) = symbols_matrix;
% No ifftshift is needed for this direct mapping.

% 4. Perform IFFT
time_domain_symbols = ifft(ofdm_frame, n_fft, 1);

% 5. Add Cyclic Prefix (CP)
cp_data = time_domain_symbols((end - n_cp + 1):end, :);
ofdm_symbols_with_cp = [cp_data; time_domain_symbols];

% 6. Serialize the output
% Reshape the matrix into a single column vector
tx_signal = ofdm_symbols_with_cp(:);

% Normalize the transmitted signal to have unit power
tx_signal = tx_signal / sqrt(mean(abs(tx_signal).^2));

end
