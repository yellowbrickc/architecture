import akka.actor.{Actor, PoisonPill, Props}
import akka.cluster.sharding.{ClusterSharding, ClusterShardingSettings, ShardRegion}
import akka.cluster.singleton.{ClusterSingletonManager, ClusterSingletonManagerSettings}

object Contract {
  def props: Props = Props[Contract]

  def shardName = "contract"

  val numberOfShards = 100

  val extractEntityId: ShardRegion.ExtractEntityId = {
    case cmd: Command => (cmd.contractId, cmd)
  }

  val extractShardId: ShardRegion.ExtractShardId = {
    case cmd: Command => (math.abs(cmd.contractId.hashCode) % numberOfShards).toString
  }

  sealed trait Command {
    def contractId: String
  }

  case class CreateSpecific(contractId: String) extends Command

  case class GetStatus(contractId: String) extends Command

  case class Renew(contractId: String) extends Command
}

class Contract extends Actor {
  import Contract._

  var period : Int = 0

  val contractId = self.path.name

  override def receive: Receive = {
    case CreateSpecific(_) =>
      sender ! contractId
    case GetStatus(_) =>
      sender ! s"In period $period."
    case Renew(_) =>
      period += 1
      sender ! s"Renewed contract."
  }
}

class Scheduler extends Actor {
  override def receive: Receive = ???
}

class Master extends Actor {
  val contracts = ClusterSharding(context.system).start(
    typeName = Contract.shardName,
    entityProps = Contract.props,
    settings = ClusterShardingSettings(context.system),
    extractEntityId = Contract.extractEntityId,
    extractShardId = Contract.extractShardId)

  val scheduler = context.actorOf(
    ClusterSingletonManager.props(
      singletonProps = Props[Scheduler],
      terminationMessage = PoisonPill,
      settings = ClusterSingletonManagerSettings(context.system)),
    name = "scheduler")

  override def receive: Receive = {
    case x => ???
  }

}