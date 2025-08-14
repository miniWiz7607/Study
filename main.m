%% General OFDM Simulation with Rayleigh Fading
% This is the main script to run a generic OFDM simulation.
% The channel model is a frequency-flat Rayleigh fading channel.

clear all;
close all;
clc;

% Load the communications package (for Octave compatibility)
pkg load communications;

%% Simulation Parameters
% --- OFDM Parameters ---
n_fft = 64; % FFT size
n_cp = 16;  % Cyclic prefix length
n_carriers = 48; % Number of data subcarriers
modulation_order = 4; % QPSK
n_symbols = 100; % Number of OFDM symbols per simulation run

% --- Simulation Setup ---
snr_range_db = 0:2:20; % SNR range in dB
n_monte_carlo = 100; % Number of Monte Carlo simulations for averaging

% Initialize results array
ber_results = zeros(size(snr_range_db));
fprintf('OFDM Simulation with Rayleigh Fading\n');

%% Main Simulation Loop
for i_snr = 1:length(snr_range_db)
    snr_db = snr_range_db(i_snr);
    snr_linear = 10^(snr_db / 10);
    total_bit_errors = 0;
    total_bits_transmitted = 0;

    fprintf('Simulating for SNR = %d dB\n', snr_db);

    for i_mc = 1:n_monte_carlo
        % 1. OFDM Transmission
        % Generates a signal with normalized unit power
        [tx_signal, tx_bits] = ofdm_transmitter(n_fft, n_cp, n_carriers, modulation_order, n_symbols);

        % 2. Apply Fading Channel
        % Generate a single Rayleigh fading coefficient for the packet.
        % This models a slow, flat-fading channel.
        % The power of h is E[|h|^2] = 1 on average.
        h = (randn() + 1j*randn()) / sqrt(2);

        % Apply the channel to the signal
        rx_signal = h * tx_signal;

        % 3. Add AWGN
        % Signal power is 1 (normalized tx) * E[|h|^2] = 1.
        % Noise power is set relative to signal power to achieve the target SNR.
        noise_power = 1 / snr_linear;
        noise = sqrt(noise_power/2) * (randn(size(rx_signal)) + 1j*randn(size(rx_signal)));
        rx_signal = rx_signal + noise;

        % 4. OFDM Reception
        % The receiver needs to know the channel coefficient 'h' to equalize.
        rx_bits = ofdm_receiver(rx_signal, n_fft, n_cp, n_carriers, modulation_order, h);

        % 5. Calculate Bit Errors
        [n_errors, n_bits] = calculate_ber(tx_bits, rx_bits);
        total_bit_errors = total_bit_errors + n_errors;
        total_bits_transmitted = total_bits_transmitted + n_bits;
    end

    % Calculate average BER for this SNR
    ber_results(i_snr) = total_bit_errors / total_bits_transmitted;
    fprintf('BER = %e\n', ber_results(i_snr));
end

%% Plot Results
figure;
semilogy(snr_range_db, ber_results, 'bo-', 'LineWidth', 2);
grid on;
title('OFDM over Rayleigh Fading Channel');
xlabel('SNR (dB)');
ylabel('Bit Error Rate (BER)');
legend('Simulated BER (QPSK)');
axis([min(snr_range_db) max(snr_range_db) 1e-5 1]);

disp('Simulation finished.');
