`timescale 1ns / 10ps

module usb_buffer(
    input logic clk, n_rst, flush, get_rx_data, store_tx_data, clear, get_tx_packet_data, store_rx_packet_data, 
    input logic [7:0] tx_data, rx_packet_data,
    output logic buffer_full, 
    output logic [6:0] buffer_occupancy,
    output logic [7:0] rx_data, tx_packet_data
);

// DEFINE ALL REGS WE WILL BE USING (0,1,2, ... , 62, 63)

logic [7:0] n_REG0, n_REG1, n_REG2, n_REG3, n_REG4, n_REG5, n_REG6, n_REG7, n_REG8, n_REG9, n_REG10, n_REG11, n_REG12, n_REG13, n_REG14, n_REG15, n_REG16, n_REG17, n_REG18, n_REG19, n_REG20, n_REG21, n_REG22, n_REG23, n_REG24, n_REG25, n_REG26, n_REG27, n_REG28, n_REG29, n_REG30, n_REG31, n_REG32, n_REG33, n_REG34, n_REG35, n_REG36, n_REG37, n_REG38, n_REG39, n_REG40, n_REG41, n_REG42, n_REG43, n_REG44, n_REG45, n_REG46, n_REG47, n_REG48, n_REG49, n_REG50, n_REG51, n_REG52, n_REG53, n_REG54, n_REG55, n_REG56, n_REG57, n_REG58, n_REG59, n_REG60, n_REG61, n_REG62, n_REG63;
logic [7:0] c_REG0, c_REG1, c_REG2, c_REG3, c_REG4, c_REG5, c_REG6, c_REG7, c_REG8, c_REG9, c_REG10, c_REG11, c_REG12, c_REG13, c_REG14, c_REG15, c_REG16, c_REG17, c_REG18, c_REG19, c_REG20, c_REG21, c_REG22, c_REG23, c_REG24, c_REG25, c_REG26, c_REG27, c_REG28, c_REG29, c_REG30, c_REG31, c_REG32, c_REG33, c_REG34, c_REG35, c_REG36, c_REG37, c_REG38, c_REG39, c_REG40, c_REG41, c_REG42, c_REG43, c_REG44, c_REG45, c_REG46, c_REG47, c_REG48, c_REG49, c_REG50, c_REG51, c_REG52, c_REG53, c_REG54, c_REG55, c_REG56, c_REG57, c_REG58, c_REG59, c_REG60, c_REG61, c_REG62, c_REG63;
// Realized midway that my RTL actually has these as all different regs that are getting updated. 
logic [6:0] w_reg, r_reg, n_w_reg, n_r_reg; // these will be the pointers to the correct positions. they need 7 bits to get to position 63.
logic [7:0] n_rx_data, n_tx_packet_data;

always_comb begin
    // initial
    n_REG0 = c_REG0;
    n_REG1 = c_REG1;
    n_REG2 = c_REG2;
    n_REG3 = c_REG3;
    n_REG4 = c_REG4;
    n_REG5 = c_REG5;
    n_REG6 = c_REG6;
    n_REG7 = c_REG7;
    n_REG8 = c_REG8;
    n_REG9 = c_REG9;
    n_REG10 = c_REG10;
    n_REG11 = c_REG11;
    n_REG12 = c_REG12;
    n_REG13 = c_REG13;
    n_REG14 = c_REG14;
    n_REG15 = c_REG15;
    n_REG16 = c_REG16;
    n_REG17 = c_REG17;
    n_REG18 = c_REG18;
    n_REG19 = c_REG19;
    n_REG20 = c_REG20;
    n_REG21 = c_REG21;
    n_REG22 = c_REG22;
    n_REG23 = c_REG23;
    n_REG24 = c_REG24;
    n_REG25 = c_REG25;
    n_REG26 = c_REG26;
    n_REG27 = c_REG27;
    n_REG28 = c_REG28;
    n_REG29 = c_REG29;
    n_REG30 = c_REG30;
    n_REG31 = c_REG31;
    n_REG32 = c_REG32;
    n_REG33 = c_REG33;
    n_REG34 = c_REG34;
    n_REG35 = c_REG35;
    n_REG36 = c_REG36;
    n_REG37 = c_REG37;
    n_REG38 = c_REG38;
    n_REG39 = c_REG39;
    n_REG40 = c_REG40;
    n_REG41 = c_REG41;
    n_REG42 = c_REG42;
    n_REG43 = c_REG43;
    n_REG44 = c_REG44;
    n_REG45 = c_REG45;
    n_REG46 = c_REG46;
    n_REG47 = c_REG47;
    n_REG48 = c_REG48;
    n_REG49 = c_REG49;
    n_REG50 = c_REG50;
    n_REG51 = c_REG51;
    n_REG52 = c_REG52;
    n_REG53 = c_REG53;
    n_REG54 = c_REG54;
    n_REG55 = c_REG55;
    n_REG56 = c_REG56;
    n_REG57 = c_REG57;
    n_REG58 = c_REG58;
    n_REG59 = c_REG59;
    n_REG60 = c_REG60;
    n_REG61 = c_REG61;
    n_REG62 = c_REG62;
    n_REG63 = c_REG63;

    // system reset
    if (clear || flush) begin
        n_REG0 = 8'b0;
        n_REG1 = 8'b0;
        n_REG2 = 8'b0;
        n_REG3 = 8'b0;
        n_REG4 = 8'b0;
        n_REG5 = 8'b0;
        n_REG6 = 8'b0;
        n_REG7 = 8'b0;
        n_REG8 = 8'b0;
        n_REG9 = 8'b0;
        n_REG10 = 8'b0;
        n_REG11 = 8'b0;
        n_REG12 = 8'b0;
        n_REG13 = 8'b0;
        n_REG14 = 8'b0;
        n_REG15 = 8'b0;
        n_REG16 = 8'b0;
        n_REG17 = 8'b0;
        n_REG18 = 8'b0;
        n_REG19 = 8'b0;
        n_REG20 = 8'b0;
        n_REG21 = 8'b0;
        n_REG22 = 8'b0;
        n_REG23 = 8'b0;
        n_REG24 = 8'b0;
        n_REG25 = 8'b0;
        n_REG26 = 8'b0;
        n_REG27 = 8'b0;
        n_REG28 = 8'b0;
        n_REG29 = 8'b0;
        n_REG30 = 8'b0;
        n_REG31 = 8'b0;
        n_REG32 = 8'b0;
        n_REG33 = 8'b0;
        n_REG34 = 8'b0;
        n_REG35 = 8'b0;
        n_REG36 = 8'b0;
        n_REG37 = 8'b0;
        n_REG38 = 8'b0;
        n_REG39 = 8'b0;
        n_REG40 = 8'b0;
        n_REG41 = 8'b0;
        n_REG42 = 8'b0;
        n_REG43 = 8'b0;
        n_REG44 = 8'b0;
        n_REG45 = 8'b0;
        n_REG46 = 8'b0;
        n_REG47 = 8'b0;
        n_REG48 = 8'b0;
        n_REG49 = 8'b0;
        n_REG50 = 8'b0;
        n_REG51 = 8'b0;
        n_REG52 = 8'b0;
        n_REG53 = 8'b0;
        n_REG54 = 8'b0;
        n_REG55 = 8'b0;
        n_REG56 = 8'b0;
        n_REG57 = 8'b0;
        n_REG58 = 8'b0;
        n_REG59 = 8'b0;
        n_REG60 = 8'b0;
        n_REG61 = 8'b0;
        n_REG62 = 8'b0;
        n_REG63 = 8'b0;
    end else if (store_tx_data) begin
        case (w_reg)
            7'd0: begin 
                n_REG0 = tx_data;
            end
            7'd1: begin
                n_REG1 = tx_data;
            end
            7'd2: begin
                n_REG2 = tx_data;
            end
            7'd3: begin
                n_REG3 = tx_data;
            end
            7'd4: begin
                n_REG4 = tx_data;
            end
            7'd5: begin
                n_REG5 = tx_data;
            end
            7'd6: begin
                n_REG6 = tx_data;
            end
            7'd7: begin
                n_REG7 = tx_data;
            end
            7'd8: begin
                n_REG8 = tx_data;
            end
            7'd9: begin
                n_REG9 = tx_data;
            end
            7'd10: begin
                n_REG10 = tx_data;
            end
            7'd11: begin
                n_REG11 = tx_data;
            end
            7'd12: begin
                n_REG12 = tx_data;
            end
            7'd13: begin
                n_REG13 = tx_data;
            end
            7'd14: begin
                n_REG14 = tx_data;
            end
            7'd15: begin
                n_REG15 = tx_data;
            end
            7'd16: begin
                n_REG16 = tx_data;
            end
            7'd17: begin
                n_REG17 = tx_data;
            end
            7'd18: begin
                n_REG18 = tx_data;
            end
            7'd19: begin
                n_REG19 = tx_data;
            end
            7'd20: begin
                n_REG20 = tx_data;
            end
            7'd21: begin
                n_REG21 = tx_data;
            end
            7'd22: begin
                n_REG22 = tx_data;
            end
            7'd23: begin
                n_REG23 = tx_data;
            end
            7'd24: begin
                n_REG24 = tx_data;
            end
            7'd25: begin
                n_REG25 = tx_data;
            end
            7'd26: begin
                n_REG26 = tx_data;
            end
            7'd27: begin
                n_REG27 = tx_data;
            end
            7'd28: begin
                n_REG28 = tx_data;
            end
            7'd29: begin
                n_REG29 = tx_data;
            end 
            7'd30: begin
                n_REG30 = tx_data;
            end
            7'd31: begin
                n_REG31 = tx_data;
            end
            7'd32: begin
                n_REG32 = tx_data;
            end
            7'd33: begin
                n_REG33 = tx_data;
            end
            7'd34: begin
                n_REG34 = tx_data;
            end
            7'd35: begin
                n_REG35 = tx_data;
            end
            7'd36: begin
                n_REG36 = tx_data;
            end
            7'd37: begin
                n_REG37 = tx_data;
            end
            7'd38: begin
                n_REG38 = tx_data;
            end
            7'd39: begin
                n_REG39 = tx_data;
            end
            7'd40: begin
                n_REG40 = tx_data;
            end
            7'd41: begin
                n_REG41 = tx_data;
            end
            7'd42: begin
                n_REG42 = tx_data;
            end
            7'd43: begin
                n_REG43 = tx_data;
            end
            7'd44: begin
                n_REG44 = tx_data;
            end
            7'd45: begin
                n_REG45 = tx_data;
            end
            7'd46: begin
                n_REG46 = tx_data;
            end 
            7'd47: begin
                n_REG47 = tx_data;
            end
            7'd48: begin
                n_REG48 = tx_data;
            end
            7'd49: begin
                n_REG49 = tx_data;
            end
            7'd50: begin
                n_REG50 = tx_data;
            end
            7'd51: begin
                n_REG51 = tx_data;
            end
            7'd52: begin
                n_REG52 = tx_data;
            end
            7'd53: begin
                n_REG53 = tx_data;
            end
            7'd54: begin
                n_REG54 = tx_data;
            end
            7'd55: begin
                n_REG55 = tx_data;
            end
            7'd56: begin
                n_REG56 = tx_data;
            end
            7'd57: begin
                n_REG57 = tx_data;
            end
            7'd58: begin
                n_REG58 = tx_data;
            end
            7'd59: begin
                n_REG59 = tx_data;
            end
            7'd60: begin
                n_REG60 = tx_data;
            end
            7'd61: begin
                n_REG61 = tx_data;
            end
            7'd62: begin
                n_REG62 = tx_data;
            end
            7'd63: begin
                n_REG63 = tx_data;
            end
            default: begin
                // never to be reached
                // doesn't matter what is in here.
                n_REG0 = 8'b10010101;
            end
        endcase
    end else if (store_rx_packet_data) begin
        case (w_reg)

            7'd0: begin 
                n_REG0 = rx_packet_data;
            end
            7'd1: begin
                n_REG1 = rx_packet_data;
            end
            7'd2: begin
                n_REG2 = rx_packet_data;
            end
            7'd3: begin
                n_REG3 = rx_packet_data;
            end
            7'd4: begin
                n_REG4 = rx_packet_data;
            end
            7'd5: begin
                n_REG5 = rx_packet_data;
            end
            7'd6: begin
                n_REG6 = rx_packet_data;
            end
            7'd7: begin
                n_REG7 = rx_packet_data;
            end
            7'd8: begin
                n_REG8 = rx_packet_data;
            end
            7'd9: begin
                n_REG9 = rx_packet_data;
            end
            7'd10: begin
                n_REG10 = rx_packet_data;
            end
            7'd11: begin
                n_REG11 = rx_packet_data;
            end
            7'd12: begin
                n_REG12 = rx_packet_data;
            end
            7'd13: begin
                n_REG13 = rx_packet_data;
            end
            7'd14: begin
                n_REG14 = rx_packet_data;
            end
            7'd15: begin
                n_REG15 = rx_packet_data;
            end
            7'd16: begin
                n_REG16 = rx_packet_data;
            end
            7'd17: begin
                n_REG17 = rx_packet_data;
            end
            7'd18: begin
                n_REG18 = rx_packet_data;
            end
            7'd19: begin
                n_REG19 = rx_packet_data;
            end
            7'd20: begin
                n_REG20 = rx_packet_data;
            end
            7'd21: begin
                n_REG21 = rx_packet_data;
            end
            7'd22: begin
                n_REG22 = rx_packet_data;
            end
            7'd23: begin
                n_REG23 = rx_packet_data;
            end
            7'd24: begin
                n_REG24 = rx_packet_data;
            end
            7'd25: begin
                n_REG25 = rx_packet_data;
            end
            7'd26: begin
                n_REG26 = rx_packet_data;
            end
            7'd27: begin
                n_REG27 = rx_packet_data;
            end
            7'd28: begin
                n_REG28 = rx_packet_data;
            end
            7'd29: begin
                n_REG29 = rx_packet_data;
            end 
            7'd30: begin
                n_REG30 = rx_packet_data;
            end
            7'd31: begin
                n_REG31 = rx_packet_data;
            end
            7'd32: begin
                n_REG32 = rx_packet_data;
            end
            7'd33: begin
                n_REG33 = rx_packet_data;
            end
            7'd34: begin
                n_REG34 = rx_packet_data;
            end
            7'd35: begin
                n_REG35 = rx_packet_data;
            end
            7'd36: begin
                n_REG36 = rx_packet_data;
            end
            7'd37: begin
                n_REG37 = rx_packet_data;
            end
            7'd38: begin
                n_REG38 = rx_packet_data;
            end
            7'd39: begin
                n_REG39 = rx_packet_data;
            end
            7'd40: begin
                n_REG40 = rx_packet_data;
            end
            7'd41: begin
                n_REG41 = rx_packet_data;
            end
            7'd42: begin
                n_REG42 = rx_packet_data;
            end
            7'd43: begin
                n_REG43 = rx_packet_data;
            end
            7'd44: begin
                n_REG44 = rx_packet_data;
            end
            7'd45: begin
                n_REG45 = rx_packet_data;
            end
            7'd46: begin
                n_REG46 = rx_packet_data;
            end 
            7'd47: begin
                n_REG47 = rx_packet_data;
            end
            7'd48: begin
                n_REG48 = rx_packet_data;
            end
            7'd49: begin
                n_REG49 = rx_packet_data;
            end
            7'd50: begin
                n_REG50 = rx_packet_data;
            end
            7'd51: begin
                n_REG51 = rx_packet_data;
            end
            7'd52: begin
                n_REG52 = rx_packet_data;
            end
            7'd53: begin
                n_REG53 = rx_packet_data;
            end
            7'd54: begin
                n_REG54 = rx_packet_data;
            end
            7'd55: begin
                n_REG55 = rx_packet_data;
            end
            7'd56: begin
                n_REG56 = rx_packet_data;
            end
            7'd57: begin
                n_REG57 = rx_packet_data;
            end
            7'd58: begin
                n_REG58 = rx_packet_data;
            end
            7'd59: begin
                n_REG59 = rx_packet_data;
            end
            7'd60: begin
                n_REG60 = rx_packet_data;
            end
            7'd61: begin
                n_REG61 = rx_packet_data;
            end
            7'd62: begin
                n_REG62 = rx_packet_data;
            end
            7'd63: begin
                n_REG63 = rx_packet_data;
            end
            default: begin
                // never to be reached
                // doesn't matter what is in here.
                n_REG0 = 8'b10010101;
            end
        endcase
    end
end

// FF time. Great.

// next write reg and next read reg block
//assign buffer_full = (buffer_occupancy == 7'd63) ? 1'b1 : 1'b0; // decided on combinational logic for more stability.
logic n_buffer_full;
always_comb begin
    n_w_reg = w_reg;
    n_r_reg = r_reg;
    n_buffer_full = buffer_full;
    if (clear || flush) begin
        n_w_reg = '0;
        n_r_reg = '0;
    end else begin 
        if ((store_rx_packet_data == 1'b1) || (store_tx_data == 1'b1)) begin
            if (buffer_occupancy < 7'd64) begin
                n_w_reg = (w_reg + 1'b1) % 64;
                if (buffer_occupancy == 7'd63) begin
                    n_buffer_full = 1'b1;
                end else begin
                    n_buffer_full = 1'b0;
                end
            end
        end
        if ((get_rx_data == 1'b1) || (get_tx_packet_data == 1'b1)) begin
            n_r_reg = (r_reg + 1'b1) % 64;
            n_buffer_full = 1'b0;
        end
    end
end

always_ff @(posedge clk, negedge n_rst) begin
    if (!n_rst) begin
        w_reg <= 7'b0;
        buffer_full <= 1'b0;
        rx_data <= 8'b0;
        tx_packet_data <= 8'b0;
        r_reg <= 7'b0;
        c_REG0 <= 8'b0;
        c_REG1 <= 8'b0;
        c_REG2 <= 8'b0;
        c_REG3 <= 8'b0;
        c_REG4 <= 8'b0;
        c_REG5 <= 8'b0;
        c_REG6 <= 8'b0;
        c_REG7 <= 8'b0;
        c_REG8 <= 8'b0;
        c_REG9 <= 8'b0;
        c_REG10 <= 8'b0;
        c_REG11 <= 8'b0;
        c_REG12 <= 8'b0;
        c_REG13 <= 8'b0;
        c_REG14 <= 8'b0;
        c_REG15 <= 8'b0;
        c_REG16 <= 8'b0;
        c_REG17 <= 8'b0;
        c_REG18 <= 8'b0;
        c_REG19 <= 8'b0;
        c_REG20 <= 8'b0;
        c_REG21 <= 8'b0;
        c_REG22 <= 8'b0;
        c_REG23 <= 8'b0;
        c_REG24 <= 8'b0;
        c_REG25 <= 8'b0;
        c_REG26 <= 8'b0;
        c_REG27 <= 8'b0;
        c_REG28 <= 8'b0;
        c_REG29 <= 8'b0;
        c_REG30 <= 8'b0;
        c_REG31 <= 8'b0;
        c_REG32 <= 8'b0;
        c_REG33 <= 8'b0;
        c_REG34 <= 8'b0;
        c_REG35 <= 8'b0;
        c_REG36 <= 8'b0;
        c_REG37 <= 8'b0;
        c_REG38 <= 8'b0;
        c_REG39 <= 8'b0;
        c_REG40 <= 8'b0;
        c_REG41 <= 8'b0;
        c_REG42 <= 8'b0;
        c_REG43 <= 8'b0;
        c_REG44 <= 8'b0;
        c_REG45 <= 8'b0;
        c_REG46 <= 8'b0;
        c_REG47 <= 8'b0;
        c_REG48 <= 8'b0;
        c_REG49 <= 8'b0;
        c_REG50 <= 8'b0;
        c_REG51 <= 8'b0;
        c_REG52 <= 8'b0;
        c_REG53 <= 8'b0;
        c_REG54 <= 8'b0;
        c_REG55 <= 8'b0;
        c_REG56 <= 8'b0;
        c_REG57 <= 8'b0;
        c_REG58 <= 8'b0;
        c_REG59 <= 8'b0;
        c_REG60 <= 8'b0;
        c_REG61 <= 8'b0;
        c_REG62 <= 8'b0;
        c_REG63 <= 8'b0;
    end else begin
        w_reg <= n_w_reg;
        buffer_full <= n_buffer_full;
        rx_data <= n_rx_data;
        tx_packet_data <= n_tx_packet_data;
        r_reg <= n_r_reg;
        c_REG0 <= n_REG0;
        c_REG1 <= n_REG1;
        c_REG2 <= n_REG2;
        c_REG3 <= n_REG3;
        c_REG4 <= n_REG4;
        c_REG5 <= n_REG5;
        c_REG6 <= n_REG6;
        c_REG7 <= n_REG7;
        c_REG8 <= n_REG8;
        c_REG9 <= n_REG9;
        c_REG10 <= n_REG10;
        c_REG11 <= n_REG11;
        c_REG12 <= n_REG12;
        c_REG13 <= n_REG13;
        c_REG14 <= n_REG14;
        c_REG15 <= n_REG15;
        c_REG16 <= n_REG16;
        c_REG17 <= n_REG17;
        c_REG18 <= n_REG18;
        c_REG19 <= n_REG19;
        c_REG20 <= n_REG20;
        c_REG21 <= n_REG21;
        c_REG22 <= n_REG22;
        c_REG23 <= n_REG23;
        c_REG24 <= n_REG24;
        c_REG25 <= n_REG25;
        c_REG26 <= n_REG26;
        c_REG27 <= n_REG27;
        c_REG28 <= n_REG28;
        c_REG29 <= n_REG29;
        c_REG30 <= n_REG30;
        c_REG31 <= n_REG31;
        c_REG32 <= n_REG32;
        c_REG33 <= n_REG33;
        c_REG34 <= n_REG34;
        c_REG35 <= n_REG35;
        c_REG36 <= n_REG36;
        c_REG37 <= n_REG37;
        c_REG38 <= n_REG38;
        c_REG39 <= n_REG39;
        c_REG40 <= n_REG40;
        c_REG41 <= n_REG41;
        c_REG42 <= n_REG42;
        c_REG43 <= n_REG43;
        c_REG44 <= n_REG44;
        c_REG45 <= n_REG45;
        c_REG46 <= n_REG46;
        c_REG47 <= n_REG47;
        c_REG48 <= n_REG48;
        c_REG49 <= n_REG49;
        c_REG50 <= n_REG50;
        c_REG51 <= n_REG51;
        c_REG52 <= n_REG52;
        c_REG53 <= n_REG53;
        c_REG54 <= n_REG54;
        c_REG55 <= n_REG55;
        c_REG56 <= n_REG56;
        c_REG57 <= n_REG57;
        c_REG58 <= n_REG58;
        c_REG59 <= n_REG59;
        c_REG60 <= n_REG60;
        c_REG61 <= n_REG61;
        c_REG62 <= n_REG62;
        c_REG63 <= n_REG63;
    end
end

// time for outputs of RX Data and TX Packet Data
// this simply just is another always comb block
/* verilator lint_off LATCH */

// THESE ARE USELESS. This is causing errors. This is not awesome. 
// I have to put these in always_comb blocks :D
/*
assign tx_packet_data = (get_tx_packet_data == 1'b1) ? 
                        (r_reg == 7'd0) ? c_REG0 :
                        (r_reg == 7'd1) ? c_REG1 :
                        (r_reg == 7'd2) ? c_REG2 :
                        (r_reg == 7'd3) ? c_REG3 :
                        (r_reg == 7'd4) ? c_REG4 :
                        (r_reg == 7'd5) ? c_REG5 :
                        (r_reg == 7'd6) ? c_REG6 :
                        (r_reg == 7'd7) ? c_REG7 :
                        (r_reg == 7'd8) ? c_REG8 :
                        (r_reg == 7'd9) ? c_REG9 :
                        (r_reg == 7'd10) ? c_REG10 :
                        (r_reg == 7'd11) ? c_REG11 :
                        (r_reg == 7'd12) ? c_REG12 :
                        (r_reg == 7'd13) ? c_REG13 :
                        (r_reg == 7'd14) ? c_REG14 :
                        (r_reg == 7'd15) ? c_REG15 :
                        (r_reg == 7'd16) ? c_REG16 :
                        (r_reg == 7'd17) ? c_REG17 :
                        (r_reg == 7'd18) ? c_REG18 :
                        (r_reg == 7'd19) ? c_REG19 :
                        (r_reg == 7'd20) ? c_REG20 :
                        (r_reg == 7'd21) ? c_REG21 :
                        (r_reg == 7'd22) ? c_REG22 :
                        (r_reg == 7'd23) ? c_REG23 :
                        (r_reg == 7'd24) ? c_REG24 :
                        (r_reg == 7'd25) ? c_REG25 :
                        (r_reg == 7'd26) ? c_REG26 :
                        (r_reg == 7'd27) ? c_REG27 :
                        (r_reg == 7'd28) ? c_REG28 :
                        (r_reg == 7'd29) ? c_REG29 :
                        (r_reg == 7'd30) ? c_REG30 :
                        (r_reg == 7'd31) ? c_REG31 :
                        (r_reg == 7'd32) ? c_REG32 :
                        (r_reg == 7'd33) ? c_REG33 :
                        (r_reg == 7'd34) ? c_REG34 :
                        (r_reg == 7'd35) ? c_REG35 :
                        (r_reg == 7'd36) ? c_REG36 :
                        (r_reg == 7'd37) ? c_REG37 :
                        (r_reg == 7'd38) ? c_REG38 :
                        (r_reg == 7'd39) ? c_REG39 :
                        (r_reg == 7'd40) ? c_REG40 :
                        (r_reg == 7'd41) ? c_REG41 :
                        (r_reg == 7'd42) ? c_REG42 :
                        (r_reg == 7'd43) ? c_REG43 :
                        (r_reg == 7'd44) ? c_REG44 :
                        (r_reg == 7'd45) ? c_REG45 :
                        (r_reg == 7'd46) ? c_REG46 :
                        (r_reg == 7'd47) ? c_REG47 :
                        (r_reg == 7'd48) ? c_REG48 :
                        (r_reg == 7'd49) ? c_REG49 :
                        (r_reg == 7'd50) ? c_REG50 :
                        (r_reg == 7'd51) ? c_REG51 :
                        (r_reg == 7'd52) ? c_REG52 :
                        (r_reg == 7'd53) ? c_REG53 : 
                        (r_reg == 7'd54) ? c_REG54 :
                        (r_reg == 7'd55) ? c_REG55 :
                        (r_reg == 7'd56) ? c_REG56 :
                        (r_reg == 7'd57) ? c_REG57 : 
                        (r_reg == 7'd58) ? c_REG58 :
                        (r_reg == 7'd59) ? c_REG59 :
                        (r_reg == 7'd60) ? c_REG60 :
                        (r_reg == 7'd61) ? c_REG61 : 
                        (r_reg == 7'd62) ? c_REG62 :
                        (r_reg == 7'd63) ? c_REG63 : c_REG0 : '0;

assign rx_data = (get_rx_data == 1'b1) ? 
                        (r_reg == 7'd0) ? c_REG0 :
                        (r_reg == 7'd1) ? c_REG1 :
                        (r_reg == 7'd2) ? c_REG2 :
                        (r_reg == 7'd3) ? c_REG3 :
                        (r_reg == 7'd4) ? c_REG4 :
                        (r_reg == 7'd5) ? c_REG5 :
                        (r_reg == 7'd6) ? c_REG6 :
                        (r_reg == 7'd7) ? c_REG7 :
                        (r_reg == 7'd8) ? c_REG8 :
                        (r_reg == 7'd9) ? c_REG9 :
                        (r_reg == 7'd10) ? c_REG10 :
                        (r_reg == 7'd11) ? c_REG11 :
                        (r_reg == 7'd12) ? c_REG12 :
                        (r_reg == 7'd13) ? c_REG13 :
                        (r_reg == 7'd14) ? c_REG14 :
                        (r_reg == 7'd15) ? c_REG15 :
                        (r_reg == 7'd16) ? c_REG16 :
                        (r_reg == 7'd17) ? c_REG17 :
                        (r_reg == 7'd18) ? c_REG18 :
                        (r_reg == 7'd19) ? c_REG19 :
                        (r_reg == 7'd20) ? c_REG20 :
                        (r_reg == 7'd21) ? c_REG21 :
                        (r_reg == 7'd22) ? c_REG22 :
                        (r_reg == 7'd23) ? c_REG23 :
                        (r_reg == 7'd24) ? c_REG24 :
                        (r_reg == 7'd25) ? c_REG25 :
                        (r_reg == 7'd26) ? c_REG26 :
                        (r_reg == 7'd27) ? c_REG27 :
                        (r_reg == 7'd28) ? c_REG28 :
                        (r_reg == 7'd29) ? c_REG29 :
                        (r_reg == 7'd30) ? c_REG30 :
                        (r_reg == 7'd31) ? c_REG31 :
                        (r_reg == 7'd32) ? c_REG32 :
                        (r_reg == 7'd33) ? c_REG33 :
                        (r_reg == 7'd34) ? c_REG34 :
                        (r_reg == 7'd35) ? c_REG35 :
                        (r_reg == 7'd36) ? c_REG36 :
                        (r_reg == 7'd37) ? c_REG37 :
                        (r_reg == 7'd38) ? c_REG38 :
                        (r_reg == 7'd39) ? c_REG39 :
                        (r_reg == 7'd40) ? c_REG40 :
                        (r_reg == 7'd41) ? c_REG41 :
                        (r_reg == 7'd42) ? c_REG42 :
                        (r_reg == 7'd43) ? c_REG43 :
                        (r_reg == 7'd44) ? c_REG44 :
                        (r_reg == 7'd45) ? c_REG45 :
                        (r_reg == 7'd46) ? c_REG46 :
                        (r_reg == 7'd47) ? c_REG47 :
                        (r_reg == 7'd48) ? c_REG48 :
                        (r_reg == 7'd49) ? c_REG49 :
                        (r_reg == 7'd50) ? c_REG50 :
                        (r_reg == 7'd51) ? c_REG51 :
                        (r_reg == 7'd52) ? c_REG52 :
                        (r_reg == 7'd53) ? c_REG53 : 
                        (r_reg == 7'd54) ? c_REG54 :
                        (r_reg == 7'd55) ? c_REG55 :
                        (r_reg == 7'd56) ? c_REG56 :
                        (r_reg == 7'd57) ? c_REG57 : 
                        (r_reg == 7'd58) ? c_REG58 :
                        (r_reg == 7'd59) ? c_REG59 :
                        (r_reg == 7'd60) ? c_REG60 :
                        (r_reg == 7'd61) ? c_REG61 : 
                        (r_reg == 7'd62) ? c_REG62 :
                        (r_reg == 7'd63) ? c_REG63 : c_REG0 : '0;

*/

// PROBLEM. THIS gives me a latch. I am going to dothis combinationally just to avoid that nonsense. 
// This might take me a minute to rewrite :(
// DIDN'T TAKE LONG!!!! :D

// NM i guess it's back to it.

always_comb begin
    n_rx_data = rx_data;
    n_tx_packet_data = tx_packet_data;
    if (get_rx_data) begin
        case (r_reg)
            7'd0: begin 
                n_rx_data = c_REG0;
            end
            7'd1: begin
                n_rx_data = c_REG1;
            end
            7'd2: begin
                n_rx_data = c_REG2;
            end
            7'd3: begin
                n_rx_data = c_REG3;
            end
            7'd4: begin
                n_rx_data = c_REG4;
            end
            7'd5: begin
                n_rx_data = c_REG5;
            end
            7'd6: begin
                n_rx_data = c_REG6;
            end
            7'd7: begin
                n_rx_data = c_REG7;
            end
            7'd8: begin
                n_rx_data = c_REG8;
            end
            7'd9: begin
                n_rx_data = c_REG9;
            end
            7'd10: begin
                n_rx_data = c_REG10;
            end
            7'd11: begin
                n_rx_data = c_REG11;
            end
            7'd12: begin
                n_rx_data = c_REG12;
            end
            7'd13: begin
                n_rx_data = c_REG13;
            end
            7'd14: begin
                n_rx_data = c_REG14;
            end
            7'd15: begin
                n_rx_data = c_REG15;
            end
            7'd16: begin
                n_rx_data = c_REG16;
            end
            7'd17: begin
                n_rx_data = c_REG17;
            end
            7'd18: begin
                n_rx_data = c_REG18;
            end
            7'd19: begin
                n_rx_data = c_REG19;
            end
            7'd20: begin
                n_rx_data = c_REG20;
            end
            7'd21: begin
                n_rx_data = c_REG21;
            end
            7'd22: begin
                n_rx_data = c_REG22;
            end
            7'd23: begin
                n_rx_data = c_REG23;
            end
            7'd24: begin
                n_rx_data = c_REG24;
            end
            7'd25: begin
                n_rx_data = c_REG25;
            end
            7'd26: begin
                n_rx_data = c_REG26;
            end
            7'd27: begin
                n_rx_data = c_REG27;
            end
            7'd28: begin
                n_rx_data = c_REG28;
            end
            7'd29: begin
                n_rx_data = c_REG29;
            end 
            7'd30: begin
                n_rx_data = c_REG30;
            end
            7'd31: begin
                n_rx_data = c_REG31;
            end
            7'd32: begin
                n_rx_data = c_REG32;
            end
            7'd33: begin
                n_rx_data = c_REG33;
            end
            7'd34: begin
                n_rx_data = c_REG34;
            end
            7'd35: begin
                n_rx_data = c_REG35;
            end
            7'd36: begin
                n_rx_data = c_REG36;
            end
            7'd37: begin
                n_rx_data = c_REG37;
            end
            7'd38: begin
                n_rx_data = c_REG38;
            end
            7'd39: begin
                n_rx_data = c_REG39;
            end
            7'd40: begin
                n_rx_data = c_REG40;
            end
            7'd41: begin
                n_rx_data = c_REG41;
            end
            7'd42: begin
                n_rx_data = c_REG42;
            end
            7'd43: begin
                n_rx_data = c_REG43;
            end
            7'd44: begin
                n_rx_data = c_REG44;
            end
            7'd45: begin
                n_rx_data = c_REG45;
            end
            7'd46: begin
                n_rx_data = c_REG46;
            end 
            7'd47: begin
                n_rx_data = c_REG47;
            end
            7'd48: begin
                n_rx_data = c_REG48;
            end
            7'd49: begin
                n_rx_data = c_REG49;
            end
            7'd50: begin
                n_rx_data = c_REG50;
            end
            7'd51: begin
                n_rx_data = c_REG51;
            end
            7'd52: begin
                n_rx_data = c_REG52;
            end
            7'd53: begin
                n_rx_data = c_REG53;
            end
            7'd54: begin
                n_rx_data = c_REG54;
            end
            7'd55: begin
                n_rx_data = c_REG55;
            end
            7'd56: begin
                n_rx_data = c_REG56;
            end
            7'd57: begin
                n_rx_data = c_REG57;
            end
            7'd58: begin
                n_rx_data = c_REG58;
            end
            7'd59: begin
                n_rx_data = c_REG59;
            end
            7'd60: begin
                n_rx_data = c_REG60;
            end
            7'd61: begin
                n_rx_data = c_REG61;
            end
            7'd62: begin
                n_rx_data = c_REG62;
            end
            7'd63: begin
                n_rx_data = c_REG63;
            end
            default: begin
                n_rx_data = rx_data; // this should have the error signal
            end
        endcase
    end
    if (get_tx_packet_data) begin
        case (r_reg)
            7'd0: begin 
                n_tx_packet_data = c_REG0;
            end
            7'd1: begin
                n_tx_packet_data = c_REG1;
            end
            7'd2: begin
                n_tx_packet_data = c_REG2;
            end
            7'd3: begin
                n_tx_packet_data = c_REG3;
            end
            7'd4: begin
                n_tx_packet_data = c_REG4;
            end
            7'd5: begin
                n_tx_packet_data = c_REG5;
            end
            7'd6: begin
                n_tx_packet_data = c_REG6;
            end
            7'd7: begin
                n_tx_packet_data = c_REG7;
            end
            7'd8: begin
                n_tx_packet_data = c_REG8;
            end
            7'd9: begin
                n_tx_packet_data = c_REG9;
            end
            7'd10: begin
                n_tx_packet_data = c_REG10;
            end
            7'd11: begin
                n_tx_packet_data = c_REG11;
            end
            7'd12: begin
                n_tx_packet_data = c_REG12;
            end
            7'd13: begin
                n_tx_packet_data = c_REG13;
            end
            7'd14: begin
                n_tx_packet_data = c_REG14;
            end
            7'd15: begin
                n_tx_packet_data = c_REG15;
            end
            7'd16: begin
                n_tx_packet_data = c_REG16;
            end
            7'd17: begin
                n_tx_packet_data = c_REG17;
            end
            7'd18: begin
                n_tx_packet_data = c_REG18;
            end
            7'd19: begin
                n_tx_packet_data = c_REG19;
            end
            7'd20: begin
                n_tx_packet_data = c_REG20;
            end
            7'd21: begin
                n_tx_packet_data = c_REG21;
            end
            7'd22: begin
                n_tx_packet_data = c_REG22;
            end
            7'd23: begin
                n_tx_packet_data = c_REG23;
            end
            7'd24: begin
                n_tx_packet_data = c_REG24;
            end
            7'd25: begin
                n_tx_packet_data = c_REG25;
            end
            7'd26: begin
                n_tx_packet_data = c_REG26;
            end
            7'd27: begin
                n_tx_packet_data = c_REG27;
            end
            7'd28: begin
                n_tx_packet_data = c_REG28;
            end
            7'd29: begin
                n_tx_packet_data = c_REG29;
            end 
            7'd30: begin
                n_tx_packet_data = c_REG30;
            end
            7'd31: begin
                n_tx_packet_data = c_REG31;
            end
            7'd32: begin
                n_tx_packet_data = c_REG32;
            end
            7'd33: begin
                n_tx_packet_data = c_REG33;
            end
            7'd34: begin
                n_tx_packet_data = c_REG34;
            end
            7'd35: begin
                n_tx_packet_data = c_REG35;
            end
            7'd36: begin
                n_tx_packet_data = c_REG36;
            end
            7'd37: begin
                n_tx_packet_data = c_REG37;
            end
            7'd38: begin
                n_tx_packet_data = c_REG38;
            end
            7'd39: begin
                n_tx_packet_data = c_REG39;
            end
            7'd40: begin
                n_tx_packet_data = c_REG40;
            end
            7'd41: begin
                n_tx_packet_data = c_REG41;
            end
            7'd42: begin
                n_tx_packet_data = c_REG42;
            end
            7'd43: begin
                n_tx_packet_data = c_REG43;
            end
            7'd44: begin
                n_tx_packet_data = c_REG44;
            end
            7'd45: begin
                n_tx_packet_data = c_REG45;
            end
            7'd46: begin
                n_tx_packet_data = c_REG46;
            end 
            7'd47: begin
                n_tx_packet_data = c_REG47;
            end
            7'd48: begin
                n_tx_packet_data = c_REG48;
            end
            7'd49: begin
                n_tx_packet_data = c_REG49;
            end
            7'd50: begin
                n_tx_packet_data = c_REG50;
            end
            7'd51: begin
                n_tx_packet_data = c_REG51;
            end
            7'd52: begin
                n_tx_packet_data = c_REG52;
            end
            7'd53: begin
                n_tx_packet_data = c_REG53;
            end
            7'd54: begin
                n_tx_packet_data = c_REG54;
            end
            7'd55: begin
                n_tx_packet_data = c_REG55;
            end
            7'd56: begin
                n_tx_packet_data = c_REG56;
            end
            7'd57: begin
                n_tx_packet_data = c_REG57;
            end
            7'd58: begin
                n_tx_packet_data = c_REG58;
            end
            7'd59: begin
                n_tx_packet_data = c_REG59;
            end
            7'd60: begin
                n_tx_packet_data = c_REG60;
            end
            7'd61: begin
                n_tx_packet_data = c_REG61;
            end
            7'd62: begin
                n_tx_packet_data = c_REG62;
            end
            7'd63: begin
                n_tx_packet_data = c_REG63;
            end
            default: begin
                n_tx_packet_data = tx_packet_data; // Again this should have the error signal.
            end
        endcase
    end
end

/* verilator lint_on LATCH */

assign buffer_occupancy = (buffer_full == 1'b1) ? 7'b1000000 : (w_reg >= r_reg) ? w_reg - r_reg: 7'd64 - r_reg + w_reg; // buffer occupancy taken care of


endmodule

