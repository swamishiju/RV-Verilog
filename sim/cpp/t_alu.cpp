#include <Valu.h>

#include <cassert>
#include <cstdint>
#include <iostream>
#include <random>
#include <verilated.h>

struct AluResult {
    uint32_t result;
    bool z;
    bool n;
    bool c;
    bool v;
};

enum AluOp { ALU_ADD = 0, ALU_SUB = 1, ALU_AND = 2, ALU_OR = 3 };
constexpr std::array<AluOp, 10> ALL_ALU_OPS = {
    AluOp::ALU_ADD,
    AluOp::ALU_SUB,
    AluOp::ALU_AND,
    AluOp::ALU_OR,
};

static void fail(AluOp op, uint32_t a, uint32_t b, const char* field, uint32_t expected,
                 uint32_t actual);
AluResult ref_add(uint32_t a, uint32_t b);
AluResult ref_sub(uint32_t a, uint32_t b);
AluResult ref_and(uint32_t a, uint32_t b);
AluResult ref_or(uint32_t a, uint32_t b);
void check(Valu* dut, uint32_t a, uint32_t b, AluOp op);

int main(int argc, char** argv) {
    Verilated::commandArgs(argc, argv);

    auto dut = std::make_unique<Valu>();

    std::mt19937 rng(1234);

    // Directed corner cases
    uint32_t corners[] = {0x00000000, 0x00000001, 0xffffffff, 0x7fffffff,
                          0x80000000, 0x55555555, 0xaaaaaaaa};

    for (auto a : corners)
        for (auto b : corners)
            for (auto op : ALL_ALU_OPS)
                check(dut.get(), a, b, op);

    // Random testing
    for (int i = 0; i < 100000; ++i) {
        uint32_t a = rng();
        uint32_t b = rng();

        for (auto op : ALL_ALU_OPS)
            check(dut.get(), a, b, op);
    }

    std::cout << "PASS\n";
}

AluResult ref_sub(uint32_t a, uint32_t b) {
    uint64_t full = uint64_t(a) + uint64_t(~b) + 1ULL;
    uint32_t res = uint32_t(full);

    bool carry = (full >> 32) & 1;
    bool overflow = (((a ^ b) & (a ^ res)) >> 31) & 1;

    return {.result = res, .z = (res == 0), .n = (res >> 31), .c = carry, .v = overflow};
}

AluResult ref_add(uint32_t a, uint32_t b) {
    uint64_t full = uint64_t(a) + uint64_t(b);
    uint32_t res = uint32_t(full);

    bool carry = (full >> 32) & 1;
    bool overflow = (((a ^ res) & (b ^ res)) >> 31) & 1;

    return {.result = res, .z = (res == 0), .n = (res >> 31), .c = carry, .v = overflow};
}

AluResult ref_and(uint32_t a, uint32_t b) {
    uint32_t res = a & b;
    return {.result = res, .z = (res == 0), .n = (res >> 31), .c = 0, .v = 0};
}

AluResult ref_or(uint32_t a, uint32_t b) {
    uint32_t res = a | b;
    return {.result = res, .z = (res == 0), .n = (res >> 31), .c = 0, .v = 0};
}

void check(Valu* dut, uint32_t a, uint32_t b, AluOp op) {
    AluResult ref;

    switch (op) {
    case AluOp::ALU_ADD:
        ref = ref_add(a, b);
        break;

    case AluOp::ALU_SUB:
        ref = ref_sub(a, b);
        break;

    case AluOp::ALU_AND:
        ref = ref_and(a, b);
        break;

    case AluOp::ALU_OR:
        ref = ref_or(a, b);
        break;

    default:
        throw std::runtime_error("Unknown ALU op");
    }

    dut->a = a;
    dut->b = b;
    dut->ALU_Select = static_cast<uint8_t>(op);

    dut->eval();

    if (dut->out != ref.result)
        fail(op, a, b, "RESULT", ref.result, dut->out);

    if (dut->Z != ref.z)
        fail(op, a, b, "Z", ref.z, dut->Z);

    if (dut->N != ref.n)
        fail(op, a, b, "N", ref.n, dut->N);

    if (dut->C != ref.c)
        fail(op, a, b, "C", ref.c, dut->C);

    if (dut->V != ref.v)
        fail(op, a, b, "V", ref.v, dut->V);
}

#include <cstdlib>
#include <iomanip>
#include <iostream>

static const char* to_string(AluOp op) {
    switch (op) {
    case AluOp::ALU_ADD:
        return "ADD";
    case AluOp::ALU_SUB:
        return "SUB";
    case AluOp::ALU_AND:
        return "AND";
    case AluOp::ALU_OR:
        return "OR";
    }

    return "UNKNOWN";
}

static void fail(AluOp op, uint32_t a, uint32_t b, const char* field, uint32_t expected,
                 uint32_t actual) {
    std::cerr << "\nFAIL\n"
              << "op       = " << to_string(op) << '\n'
              << "a        = 0x" << std::hex << std::setw(8) << std::setfill('0') << a << '\n'
              << "b        = 0x" << std::hex << std::setw(8) << std::setfill('0') << b << '\n'
              << "field    = " << field << '\n'
              << "expected = 0x" << std::hex << expected << '\n'
              << "actual   = 0x" << std::hex << actual << '\n';

    std::exit(EXIT_FAILURE);
}
