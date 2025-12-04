module ForwardingUnit (
    input [4:0] ID_EX_Rs,    // Registro fuente 1 (viene de etapa ID/EX)
    input [4:0] ID_EX_Rt,    // Registro fuente 2 (viene de etapa ID/EX)
    input [4:0] EX_MEM_Rd,   // Registro destino actual en etapa MEM
    input EX_MEM_RegWrite,   // ¿La instrucción en MEM escribe en registro?
    input [4:0] MEM_WB_Rd,   // Registro destino actual en etapa WB
    input MEM_WB_RegWrite,   // ¿La instrucción en WB escribe en registro?
    
    output reg [1:0] ForwardA, // Control Mux A de la ALU
    output reg [1:0] ForwardB  // Control Mux B de la ALU
);

    always @(*) begin
        // Valor por defecto: 00 (No forwarding, usar dato del banco de registros)
        ForwardA = 2'b00;
        ForwardB = 2'b00;

        // ------------------------------------------------------------
        // RIESGO EX (EX Hazard)
        // El dato que necesitamos está calculado en la etapa siguiente (MEM),
        // pero aún no se ha escrito. Lo tomamos "prestado" del buffer EX/MEM.
        // ------------------------------------------------------------
        
        // Para entrada A de la ALU (Rs)
        if (EX_MEM_RegWrite && (EX_MEM_Rd != 0) && (EX_MEM_Rd == ID_EX_Rs))
            ForwardA = 2'b10;
            
        // Para entrada B de la ALU (Rt)
        if (EX_MEM_RegWrite && (EX_MEM_Rd != 0) && (EX_MEM_Rd == ID_EX_Rt))
            ForwardB = 2'b10;

        // ------------------------------------------------------------
        // RIESGO MEM (MEM Hazard)
        // El dato está en la etapa WB, a punto de escribirse.
        // Solo adelantamos si NO hubo riesgo EX (el riesgo EX tiene prioridad porque es el dato más reciente).
        // ------------------------------------------------------------

        // Para entrada A de la ALU (Rs)
        if (MEM_WB_RegWrite && (MEM_WB_Rd != 0) && 
           !(EX_MEM_RegWrite && (EX_MEM_Rd != 0) && (EX_MEM_Rd == ID_EX_Rs)) && 
           (MEM_WB_Rd == ID_EX_Rs)) begin
            ForwardA = 2'b01;
        end

        // Para entrada B de la ALU (Rt)
        if (MEM_WB_RegWrite && (MEM_WB_Rd != 0) && 
           !(EX_MEM_RegWrite && (EX_MEM_Rd != 0) && (EX_MEM_Rd == ID_EX_Rt)) && 
           (MEM_WB_Rd == ID_EX_Rt)) begin
            ForwardB = 2'b01;
        end
    end
endmodule
