import akka.actor.Actor
import akka.pattern.ask
import akka.persistence.query.{Offset, PersistenceQuery}
import akka.persistence.query.journal.leveldb.scaladsl.LeveldbReadJournal
import akka.stream.scaladsl.Sink

import scala.concurrent.Future

class ReadModel extends Actor {
  def getLastSeenOffset: Offset = ???

  def saveLastSeenOffset(offset: Offset): Future[Any] = ???

  PersistenceQuery(context.system)
    .readJournalFor[LeveldbReadJournal](LeveldbReadJournal.Identifier)
    .eventsByTag(tag = "contract", offset = this.getLastSeenOffset)
    .mapAsync(1) {
      envelope => self.ask(envelope.event).map(_ => envelope.offset)
    }
    .mapAsync(1) {
      offset => saveLastSeenOffset(offset)
    }
    .runWith(Sink.ignore)

  override def receive: Receive = {
    case event => ???
  }
}