import akka.persistence.PersistentActor

object Counter {

  case class Increase(by: Int)

  case class Decrease(by: Int)

  case class State(count: Int)

}

class Counter extends PersistentActor {

  import Counter._

  override def persistenceId: String = "counter"

  var state = State(0)

  def updateState(by: Int): Unit =
    state = state.copy(state.count + by)

  override def receiveRecover: Receive = {
    case increase: Increase => updateState(increase.by)
    case decrease: Decrease => updateState(-decrease.by)
  }

  override def receiveCommand: Receive = {
    case increase: Increase =>
      persist(increase) { event => updateState(increase.by) }
    case decrease: Decrease =>
      persist(decrease) { event => updateState(-decrease.by) }
  }
}

class AlternatingCounter extends PersistentActor {

  import Counter._

  override def persistenceId: String = "stateful-counter"

  var state = State(0)

  def updateState(by: Int): Unit =
    state = state.copy(state.count + by)

  override def receiveRecover: Receive = {
    case increase: Increase =>
      updateState(increase.by)
      context.become(canOnlyDecrease)
    case decrease: Decrease =>
      updateState(-decrease.by)
      context.become(canOnlyIncrease)
  }

  override def receiveCommand = canBothIncreaseAndDecrease

  def canOnlyDecrease: Receive = {
    case decrease: Decrease =>
      persist(decrease) {
        event =>
          updateState(-decrease.by)
          context.become(canOnlyIncrease)
      }
  }

  def canOnlyIncrease: Receive = {
    case increase: Increase =>
      persist(increase) {
        event =>
          updateState(increase.by)
          context.become(canOnlyDecrease)
      }
  }

  def canBothIncreaseAndDecrease: Receive = canOnlyDecrease orElse canOnlyIncrease
}