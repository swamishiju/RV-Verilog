#include <Vimm_gen.h>

#include <cstdint>
#include <cstdlib>
#include <iomanip>
#include <iostream>
#include <random>

enum class ImmType : uint8_t {
    IMM_I = 0,
    IMM_S = 1,
    IMM_B = 2,
    IMM_U = 3,
    IMM_J = 4,
    IMM_NONE = 5
};

uint32_t sign_extend(uint32_t value, unsigned bits);
uint32_t ref_i(uint32_t instr);
uint32_t ref_s(uint32_t instr);
uint32_t ref_b(uint32_t instr);
uint32_t ref_u(uint32_t instr);
uint32_t ref_j(uint32_t instr);

void fail(const char* test, uint32_t instr, ImmType type, uint32_t expected, uint32_t actual);
void check(Vimm_gen* dut, const char* test, uint32_t instr, ImmType type, uint32_t expected);
uint32_t reference(uint32_t instr, ImmType type);

void test_directed(Vimm_gen* dut);
void test_random(Vimm_gen* dut);

int main(int argc, char** argv) {
    auto dut = new Vimm_gen;

    test_directed(dut);
    test_random(dut);

    std::cout << "PASS\n";

    delete dut;

    return EXIT_SUCCESS;
}

uint32_t sign_extend(uint32_t value, unsigned bits) {
    const uint32_t mask = 1u << (bits - 1);
    return (value ^ mask) - mask;
}

uint32_t ref_i(uint32_t instr) { return sign_extend((instr >> 20) & 0xFFF, 12); }
uint32_t ref_s(uint32_t instr) {
    uint32_t imm = (((instr >> 25) & 0x7F) << 5) | ((instr >> 7) & 0x1F);

    return sign_extend(imm, 12);
}

uint32_t ref_b(uint32_t instr) {
    uint32_t imm = (((instr >> 31) & 0x1) << 12) | (((instr >> 7) & 0x1) << 11) |
                   (((instr >> 25) & 0x3F) << 5) | (((instr >> 8) & 0xF) << 1);

    return sign_extend(imm, 13);
}

uint32_t ref_u(uint32_t instr) { return instr & 0xFFFFF000; }

uint32_t ref_j(uint32_t instr) {
    uint32_t imm = (((instr >> 31) & 0x1) << 20) | (((instr >> 12) & 0xFF) << 12) |
                   (((instr >> 20) & 0x1) << 11) | (((instr >> 21) & 0x3FF) << 1);

    return sign_extend(imm, 21);
}

void fail(const char* test, uint32_t instr, ImmType type, uint32_t expected, uint32_t actual) {
    std::cerr << "FAIL\n"
              << "test      : " << test << '\n'
              << "instr     : 0x" << std::hex << std::setw(8) << std::setfill('0') << instr << '\n'
              << "imm_sel   : " << static_cast<int>(type) << '\n'
              << "expected  : 0x" << std::setw(8) << expected << '\n'
              << "actual    : 0x" << std::setw(8) << actual << '\n';

    std::exit(EXIT_FAILURE);
}

void check(Vimm_gen* dut, const char* test, uint32_t instr, ImmType type, uint32_t expected) {
    dut->instr = instr;
    dut->imm_sel = static_cast<uint8_t>(type);

    dut->eval();

    if (dut->imm != expected) {
        fail(test, instr, type, expected, dut->imm);
    }
}

void test_directed(Vimm_gen* dut) {
    check(dut, "I +5", 5u << 20, ImmType::IMM_I, 5u);

    check(dut, "I -1", 0xFFFu << 20, ImmType::IMM_I, 0xFFFFFFFFu);

    check(dut, "I -2048", 0x800u << 20, ImmType::IMM_I, 0xFFFFF800u);

    check(dut, "U 0x12345000", 0x12345000, ImmType::IMM_U, 0x12345000);

    std::cout << "[PASS] directed tests\n";
}

uint32_t reference(uint32_t instr, ImmType type) {
    switch (type) {
    case ImmType::IMM_I:
        return ref_i(instr);

    case ImmType::IMM_S:
        return ref_s(instr);

    case ImmType::IMM_B:
        return ref_b(instr);

    case ImmType::IMM_U:
        return ref_u(instr);

    case ImmType::IMM_J:
        return ref_j(instr);

    default:
        return 0;
    }
}

void test_random(Vimm_gen* dut) {
    std::mt19937 rng(1234);

    constexpr int NUM_TESTS = 100000;

    for (int i = 0; i < NUM_TESTS; ++i) {
        uint32_t instr = rng();

        for (ImmType type :
             {ImmType::IMM_I, ImmType::IMM_S, ImmType::IMM_B, ImmType::IMM_U, ImmType::IMM_J}) {
            uint32_t expected = reference(instr, type);

            dut->instr = instr;
            dut->imm_sel = static_cast<uint8_t>(type);

            dut->eval();

            if (dut->imm != expected) {
                std::cerr << "iteration = " << i << '\n';

                fail("random", instr, type, expected, dut->imm);
            }
        }
    }

    std::cout << "[PASS] random tests (" << NUM_TESTS << " instructions)\n";
}
