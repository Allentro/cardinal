[Mesh]
  [sphere]
    type = FileMeshGenerator
    file = ../meshes/sphere.e
  []
  [solid]
    type = CombinerGenerator
    inputs = sphere
    positions = '0 0 0
                 0 0 4
                 0 0 8'
  []
  [solid_ids]
    type = SubdomainIDGenerator
    input = solid
    subdomain_id = '100'
  []
  [fluid]
    type = FileMeshGenerator
    file = ../heat_source/stoplight.exo
  []
  [fluid_ids]
    type = SubdomainIDGenerator
    input = fluid
    subdomain_id = '200'
  []
  [combine]
    type = CombinerGenerator
    inputs = 'solid_ids fluid_ids'
  []
[]

# This AuxVariable and AuxKernel is only here to get the postprocessors
# to evaluate correctly. This can be deleted after MOOSE issue #17534 is fixed.
[AuxVariables]
  [dummy]
  []
[]

[AuxKernels]
  [dummy]
    type = ConstantAux
    variable = dummy
    value = 0.0
  []
[]

[ICs]
  [temp]
    type = ConstantIC
    variable = temp
    value = 600.0
  []
  [rho]
    type = ConstantIC
    variable = density
    value = 100.0
    block = '200'
  []
[]

[Problem]
  type = OpenMCCellAverageProblem
  verbose = true
  source_strength = 1e12
  solid_blocks = '100'
  fluid_blocks = '200'
  tally_blocks = '100 200'
  solid_cell_level = 0
  fluid_cell_level = 0
  tally_type = cell
  initial_properties = xml
[]

[Executioner]
  type = Transient
  num_steps = 1
[]

[Postprocessors]
  [heat_source]
    type = ElementIntegralVariablePostprocessor
    variable = heat_source
  []
  [heat_source_fluid]
    type = ElementIntegralVariablePostprocessor
    variable = heat_source
    block = '200'
  []
  [heat_source_solid]
    type = ElementIntegralVariablePostprocessor
    variable = heat_source
    block = '100'
  []
[]

[Outputs]
  exodus = true
  csv = true
[]
