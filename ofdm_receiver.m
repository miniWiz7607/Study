function rx_bits = ofdm_receiver(rx_signal, n_fft, n_cp, n_carriers, modulation_order, h)
% ofdm_receiver - Decodes an OFDM signal.
%
% Syntax: rx_bits = ofdm_receiver(rx_signal, n_fft, n_cp, n_carriers, modulation_order, h)
%
% Inputs:
%    rx_signal    - The received complex time-domain OFDM signal.
%    n_fft        - FFT size.
%    n_cp         - Cyclic prefix length.
%    n_carriers   - Number of data subcarriers.
%    modulation_order - Modulation order (e.g., 4 for QPSK).
%    h            - The channel coefficient for equalization.
%
% Outputs:
%    rx_bits      - The recovered bit stream.

bits_per_symbol = log2(modulation_order);
symbol_len = n_fft + n_cp;
n_symbols = length(rx_signal) / symbol_len;

% 1. Reshape the serial signal into parallel symbols
rx_signal_matrix = reshape(rx_signal, symbol_len, n_symbols);

% 2. Remove Cyclic Prefix
time_domain_symbols = rx_signal_matrix((n_cp + 1):end, :);

% 3. Perform FFT
freq_domain_symbols = fft(time_domain_symbols, n_fft, 1);

% 4. Channel Equalization (Zero-Forcing)
% We 'cheat' by using the known channel coefficient h.
% A real receiver would estimate this.
equalized_symbols = freq_domain_symbols / h;

% No frequency shift was applied in the transmitter, so none is needed here.

% 5. Extract symbols from data subcarriers (Simplified Method)
demod_symbols_matrix = equalized_symbols(2:(n_carriers + 1), :);

% Serialize the symbol matrix
received_symbols = demod_symbols_matrix(:);

% 5. Demodulate symbols to bits
% Demodulate to integer symbols
int_symbols = qamdemod(received_symbols, modulation_order);

% Convert integers to binary
rx_bits_matrix = de2bi(int_symbols, bits_per_symbol, 'left-msb');

% Transpose the matrix before serializing to match the transmitter's bit order
rx_bits_matrix = rx_bits_matrix';

% Reshape the bit matrix into a single stream
rx_bits = rx_bits_matrix(:);

end
