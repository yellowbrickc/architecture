import akka.actor.{Actor, ActorLogging, ActorRef, Props}

// Simplest actor ever
class ShoutEchoActor extends Actor {
  override def receive: Receive = {
    case s: String => sender.tell(s.toUpperCase, sender = self)
  }
}

// Actor with defined interface in Companion Object
object WhisperEchoActor {
  case class Message(s: String)
  case class Response(s: String)
}

class WhisperEchoActor extends Actor {
  import WhisperEchoActor._

  override def receive: Receive = {
    case message: Message =>
      val response = Response(message.s.toLowerCase)
      sender.tell(response, sender = self)
  }
}

// Parent-Child Relationship
class Parent extends Actor with ActorLogging {
  val child: ActorRef = context.actorOf(Props[Child], "child")

  override def receive: Receive = {
    case x =>
      log.info(s"Received message $x")
      child.tell(x, sender = self)
  }
}

class Child extends Actor with ActorLogging {
  override def receive: Receive = {
    case "Crash" => throw new NullPointerException("BOOM")
    case x => log.info(s"Received message $x")
  }
}