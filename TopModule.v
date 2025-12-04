`timescale 1ns/1ns

module MIPS_Pipeline_Top (
    input clk,
    input reset
);

    // ==============================================================================
    // CABLES (WIRES) DE INTERCONEXIÓN
    // ==============================================================================

    // --- Etapa IF ---
    wire [31:0] pc_in, pc_out, pc_plus_4;
    wire [31:0] instr;
    wire [31:0] branch_target_address;
    wire [31:0] jump_target_address;
    wire pcsrc; 

    // --- Etapa ID ---
    wire [31:0] if_id_pc_next, if_id_instr;
    wire [31:0] read_data1, read_data2, sign_ext_imm;
    
    // Señales de Control
    wire ctrl_reg_dst, ctrl_branch, ctrl_mem_read, ctrl_mem_to_reg;
    wire [1:0] ctrl_alu_op;
    wire ctrl_mem_write, ctrl_alu_src, ctrl_reg_write, ctrl_jump;
    
    // Cables ID/EX
    wire id_ex_branch, ex_mem_branch;
    wire id_ex_reg_write, id_ex_mem_to_reg, id_ex_mem_read, id_ex_mem_write;
    wire id_ex_reg_dst, id_ex_alu_src;
    wire [1:0] id_ex_alu_op;
    wire [31:0] id_ex_pc_next, id_ex_read_data1, id_ex_read_data2, id_ex_sign_ext;
    wire [4:0]  id_ex_rs, id_ex_rt, id_ex_rd;
    wire [5:0]  id_ex_opcode; 

    // Cables EX
    wire [31:0] shifted_imm; 
    wire [31:0] alu_in_a, alu_in_b_temp, alu_in_b_final;
    wire [31:0] alu_result;
    wire zero_flag;
    wire [4:0]  write_reg_addr_ex; 
    wire [3:0]  alu_control_signal;
    wire [1:0]  forward_a, forward_b; 

    // Cables MEM
    wire ex_mem_reg_write, ex_mem_mem_to_reg, ex_mem_mem_read, ex_mem_mem_write;
    wire ex_mem_zero; 
    wire [31:0] ex_mem_alu_result, ex_mem_write_data;
    wire [4:0]  ex_mem_write_reg;
    wire [31:0] mem_read_data;

    // Cables WB
    wire mem_wb_reg_write, mem_wb_mem_to_reg;
    wire [31:0] mem_wb_read_data, mem_wb_alu_result;
    wire [4:0]  mem_wb_write_reg;
    wire [31:0] result_to_write; 

    // ==============================================================================
    // ETAPA 1: INSTRUCTION FETCH (IF)
    // ==============================================================================
    
    assign pcsrc = ex_mem_branch & ex_mem_zero; 
    
    assign pc_in = (ctrl_jump) ? jump_target_address : 
                   (pcsrc)     ? branch_target_address : pc_plus_4; 

    ProgramCounter PC (
        .clk(clk), .reset(reset), 
        .enable(1'b1), 
        .pc_in(pc_in), .pc_out(pc_out)
    );

    Adder Add_PC4 (.a(pc_out), .b(32'd4), .result(pc_plus_4));

    InstructionMemory InstrMem (.address(pc_out), .instruction(instr));

    // ==============================================================================
    // BUFFER IF/ID
    // ==============================================================================
    IF_ID_Buffer IF_ID (
        .clk(clk), .reset(reset), 
        .enable(1'b1),
        .pc_next_in(pc_plus_4), .instr_in(instr),
        .pc_next_out(if_id_pc_next), .instr_out(if_id_instr)
    );

    // ==============================================================================
    // ETAPA 2: INSTRUCTION DECODE (ID)
    // ==============================================================================

    ControlUnit Control (
        .opcode(if_id_instr[31:26]),
        // Corrección de mayúsculas para coincidir con el módulo ControlUnit
        .RegDst(ctrl_reg_dst),      
        .Branch(ctrl_branch), 
        .MemRead(ctrl_mem_read),
        .MemToReg(ctrl_mem_to_reg), 
        .ALUOp(ctrl_alu_op), 
        .MemWrite(ctrl_mem_write),
        .ALUSrc(ctrl_alu_src), 
        .RegWrite(ctrl_reg_write),
        .Jump(ctrl_jump) 
    );

    RegisterFile RegFile (
        .clk(clk), .reg_write(mem_wb_reg_write),
        .read_reg1(if_id_instr[25:21]), .read_reg2(if_id_instr[20:16]),
        .write_reg(mem_wb_write_reg), .write_data(result_to_write),
        .read_data1(read_data1), .read_data2(read_data2)
    );

    SignExtend SignExt (.in(if_id_instr[15:0]), .out(sign_ext_imm));

    assign jump_target_address = {if_id_pc_next[31:28], if_id_instr[25:0], 2'b00};

    // ==============================================================================
    // BUFFER ID/EX
    // ==============================================================================
    ID_EX_Buffer ID_EX (
        .clk(clk), .reset(reset),
        // Control
        .RegWrite_in(ctrl_reg_write), .MemtoReg_in(ctrl_mem_to_reg),
        .MemRead_in(ctrl_mem_read), .MemWrite_in(ctrl_mem_write),
        .RegDst_in(ctrl_reg_dst), .ALUSrc_in(ctrl_alu_src),
        .ALUOp_in(ctrl_alu_op), .Branch_in(ctrl_branch),
        
        // Datos
        .pc_next_in(if_id_pc_next), .read_data1_in(read_data1), .read_data2_in(read_data2),
        .sign_ext_in(sign_ext_imm),
        .rs_in(if_id_instr[25:21]), .rt_in(if_id_instr[20:16]), .rd_in(if_id_instr[15:11]),
        .opcode_in(if_id_instr[31:26]), 
        
        // Salidas
        .RegWrite_out(id_ex_reg_write), .MemtoReg_out(id_ex_mem_to_reg),
        .MemRead_out(id_ex_mem_read), .MemWrite_out(id_ex_mem_write),
        .RegDst_out(id_ex_reg_dst), .ALUSrc_out(id_ex_alu_src), .ALUOp_out(id_ex_alu_op),
        .Branch_out(id_ex_branch),
        
        .pc_next_out(id_ex_pc_next), .read_data1_out(id_ex_read_data1), .read_data2_out(id_ex_read_data2),
        .sign_ext_out(id_ex_sign_ext),
        .rs_out(id_ex_rs), .rt_out(id_ex_rt), .rd_out(id_ex_rd),
        .opcode_out(id_ex_opcode) 
    );

    // ==============================================================================
    // ETAPA 3: EXECUTE (EX)
    // ==============================================================================

    ForwardingUnit Forwarding (
        .ID_EX_Rs(id_ex_rs), .ID_EX_Rt(id_ex_rt),
        .EX_MEM_Rd(ex_mem_write_reg), .EX_MEM_RegWrite(ex_mem_reg_write),
        .MEM_WB_Rd(mem_wb_write_reg), .MEM_WB_RegWrite(mem_wb_reg_write),
        .ForwardA(forward_a), .ForwardB(forward_b)
    );

    assign alu_in_a = (forward_a == 2'b10) ? ex_mem_alu_result :
                      (forward_a == 2'b01) ? result_to_write : id_ex_read_data1;

    assign alu_in_b_temp = (forward_b == 2'b10) ? ex_mem_alu_result :
                           (forward_b == 2'b01) ? result_to_write : id_ex_read_data2;

    assign alu_in_b_final = (id_ex_alu_src) ? id_ex_sign_ext : alu_in_b_temp;

    assign write_reg_addr_ex = (id_ex_reg_dst) ? id_ex_rd : id_ex_rt;

    ShiftLeft2 Shift_Branch (.in(id_ex_sign_ext), .out(shifted_imm));
    
    Adder Add_Branch (.a(id_ex_pc_next), .b(shifted_imm), .result(branch_target_address));

    ALUControl ALU_Ctrl (
        .alu_op(id_ex_alu_op), 
        .funct(id_ex_sign_ext[5:0]), 
        .opcode(id_ex_opcode), 
        .alu_control_out(alu_control_signal)
    );

    // Asegúrate de que tu módulo ALU se llame 'module ALU' (mayúsculas)
    ALU Main_ALU (
        .a(alu_in_a), 
        .b(alu_in_b_final), 
        .alu_control(alu_control_signal),
        .result(alu_result), 
        .zero(zero_flag)
    );

    // ==============================================================================
    // BUFFER EX/MEM
    // ==============================================================================
    EX_MEM_Buffer EX_MEM (
        .clk(clk), .reset(reset),
        .RegWrite_in(id_ex_reg_write), .MemtoReg_in(id_ex_mem_to_reg),
        .MemRead_in(id_ex_mem_read), .MemWrite_in(id_ex_mem_write),
        .Branch_in(id_ex_branch),
        
        .alu_result_in(alu_result), .write_data_in(alu_in_b_temp), 
        .write_reg_in(write_reg_addr_ex),
        .Zero_in(zero_flag),
        
        // Salidas
        .RegWrite_out(ex_mem_reg_write), .MemtoReg_out(ex_mem_mem_to_reg),
        .MemRead_out(ex_mem_mem_read), .MemWrite_out(ex_mem_mem_write),
        .Branch_out(ex_mem_branch),
        .Zero_out(ex_mem_zero),
        
        .alu_result_out(ex_mem_alu_result), .write_data_out(ex_mem_write_data),
        .write_reg_out(ex_mem_write_reg)
    );

    // ==============================================================================
    // ETAPA 4: MEMORY (MEM)
    // ==============================================================================

    DataMemory DataMem (
        .clk(clk), .address(ex_mem_alu_result),
        .write_data(ex_mem_write_data),
        .mem_write(ex_mem_mem_write), .mem_read(ex_mem_mem_read),
        .read_data(mem_read_data)
    );

    // ==============================================================================
    // BUFFER MEM/WB
    // ==============================================================================
    MEM_WB_Buffer MEM_WB (
        .clk(clk), .reset(reset),
        .RegWrite_in(ex_mem_reg_write), .MemtoReg_in(ex_mem_mem_to_reg),
        .mem_read_data_in(mem_read_data), .alu_result_in(ex_mem_alu_result),
        .write_reg_in(ex_mem_write_reg),
        // Salidas
        .RegWrite_out(mem_wb_reg_write), .MemtoReg_out(mem_wb_mem_to_reg),
        .mem_read_data_out(mem_wb_read_data), .alu_result_out(mem_wb_alu_result),
        .write_reg_out(mem_wb_write_reg)
    );

    // ==============================================================================
    // ETAPA 5: WRITE BACK (WB)
    // ==============================================================================

    assign result_to_write = (mem_wb_mem_to_reg) ? mem_wb_read_data : mem_wb_alu_result;

endmodule