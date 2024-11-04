# frozen_string_literal: true

class ResolveButtonComponent < ViewComponent::Base
  def initialize(problem:, user: nil)
    @problem = problem
    @user = user
  end

  def before_render
    # Preload some things we'll need
    @category = @problem.category
    @problematic = @problem.problematic
    @parent_model = @problem.problematic.model if @problematic.is_a?(ModelFile)
    @strategy = @problem.resolution_strategy
  end

  def render?
    ProblemPolicy.new(@user, @problem).resolve?
  end

  def call
  end
end
