defmodule Ash.Reactor.Dsl.Read do
  @moduledoc """
  The `read` entity for the `Ash.Reactor` reactor extension.
  """

  defstruct __identifier__: nil,
            action: nil,
            action_step?: true,
            actor: [],
            api: nil,
            async?: true,
            authorize?: nil,
            description: nil,
            inputs: [],
            name: nil,
            resource: nil,
            tenant: [],
            transform: nil,
            type: :read,
            wait_for: []

  @type t :: %__MODULE__{
          __identifier__: any,
          action: atom,
          action_step?: true,
          actor: [Ash.Reactor.Dsl.Actor.t()],
          api: Ash.Api.t(),
          async?: boolean,
          authorize?: boolean | nil,
          description: String.t() | nil,
          name: atom,
          inputs: [Ash.Reactor.Dsl.Inputs.t()],
          resource: module,
          tenant: [Ash.Reactor.Dsl.Tenant.t()],
          type: :create,
          wait_for: [Reactor.Dsl.WaitFor.t()]
        }

  @doc false
  def __entity__,
    do: %Spark.Dsl.Entity{
      name: :read,
      describe: "Declares a step that will call a read action on a resource.",
      examples: [
        """
        read :read_posts, MyApp.Post, :read
        """,
        """
        read :read_posts_in_range, MyApp.Post, :read_in_range do
          inputs %{min_date: input(:min_date), max_date: input(:max_date)}
        end
        """
      ],
      no_depend_modules: [:api, :resource],
      target: __MODULE__,
      args: [:name, :resource, {:optional, :action}],
      identifier: :name,
      imports: [Reactor.Dsl.Argument],
      entities: [
        actor: [Ash.Reactor.Dsl.Actor.__entity__()],
        inputs: [Ash.Reactor.Dsl.Inputs.__entity__()],
        tenant: [Ash.Reactor.Dsl.Tenant.__entity__()],
        wait_for: [Reactor.Dsl.WaitFor.__entity__()]
      ],
      singleton_entity_keys: [:actor, :tenant],
      recursive_as: :steps,
      schema: [
        action: [
          type: :atom,
          required: false,
          doc: """
          The name of the action to call on the resource.
          """
        ],
        api: [
          type: {:spark, Ash.Api},
          required: false,
          doc:
            "The API to use when calling the action.  Defaults to the API set in the `ash` section."
        ],
        async?: [
          type: :boolean,
          required: false,
          default: true,
          doc:
            "When set to true the step will be executed asynchronously via Reactor's `TaskSupervisor`."
        ],
        authorize?: [
          type: {:or, [:boolean, nil]},
          required: false,
          default: nil,
          doc: "Explicitly enable or disable authorization for the action."
        ],
        description: [
          type: :string,
          required: false,
          doc: "A description for the step"
        ],
        name: [
          type: :atom,
          required: true,
          doc: """
          A unique name for the step.

          This is used when choosing the return value of the Reactor and for
          arguments into other steps.
          """
        ],
        resource: [
          type: {:spark, Ash.Resource},
          required: true,
          doc: """
          The resource to call the action on.
          """
        ]
      ]
    }
end
