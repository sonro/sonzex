const std = @import("std");

const libname = "sonzex";

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const lib_mod = b.addModule(libname, .{
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .optimize = optimize,
    });

    const lib_tests = b.addTest(.{
        .root_module = lib_mod,
    });

    const check_exe = b.addExecutable(.{
        .name = "sonzex",
        .root_module = lib_mod,
    });
    const check = b.step("check", "Check if compiles");
    check.dependOn(&check_exe.step);

    const run_lib_tests = b.addRunArtifact(lib_tests);
    const test_step = b.step("test", "Run tests");
    test_step.dependOn(&run_lib_tests.step);
}
