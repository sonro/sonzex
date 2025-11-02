const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const module_name = "flat_list";

    const mod = b.addModule(module_name, .{
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .optimize = optimize,
    });

    const mod_tests = b.addTest(.{
        .root_module = mod,
    });

    const lib_test_mod = b.createModule(.{
        .root_source_file = b.path("src/tests.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{.{ .name = module_name, .module = mod }},
    });

    const lib_tests = b.addTest(.{
        .root_module = lib_test_mod,
    });

    const run_mod_tests = b.addRunArtifact(mod_tests);
    const run_lib_tests = b.addRunArtifact(lib_tests);
    const test_step = b.step("test", "Run tests");
    test_step.dependOn(&run_mod_tests.step);
    test_step.dependOn(&run_lib_tests.step);
}
