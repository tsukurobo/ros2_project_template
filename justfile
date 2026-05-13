set shell := ["bash", "-c"]

ros_distro := env_var('ROS_DISTRO')

default:
  @just --list

alias dep := deps
alias b := build
alias t := test
alias r := run
alias d := doc

_cd:
  @cd {{justfile_directory()}}

# install dependencies
deps: _cd
  vcs import --input build_depends.repos --recursive .
  sudo apt update
  rosdep update --rosdistro {{ros_distro}}
  rosdep install --from-paths . --ignore-src --rosdistro {{ros_distro}} -y

# build [packages...]
build *packages: _cd
    colcon build --symlink-install {{ if packages == "" { "" } else { "--packages-select " + packages } }}

# test [packages...]
test *packages: _cd
    source install/setup.bash && \
    colcon test {{ if packages == "" { "" } else { "--packages-select " + packages } }} --event-handlers console_direct+ --return-code-on-test-failure

# run launch file from bringup package
run name: _cd
    source install/setup.bash && \
    project_name="$(basename "{{justfile_directory()}}" | sed 's/_ros2$//')" && \
    ros2 launch "${project_name}_bringup" {{name}}.launch.yaml

# clean [packages...]
clean *packages: _cd
    {{ if packages == "" { "rm -rf build install log docs_build docs_output cross_reference" } else { "for pkg in " + packages + "; do rm -rf build/$pkg install/$pkg log/$pkg; done" } }}

# doc [packages...]
doc *packages: _cd
    source install/setup.bash && \
    colcon list {{ if packages != "" { "--packages-select " + packages } else { "" } }} --paths-only | xargs rosdoc2 build -p

# format [packages...]
format *packages: _cd
    colcon list {{ if packages != "" { "--packages-select " + packages } else { "" } }} --paths-only | xargs ament_clang_format --reformat
