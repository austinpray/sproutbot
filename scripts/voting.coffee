module.exports = (robot) ->

  class Poll
    constructor: (config) ->
      config.title or= 'Generic Poll'
      {@title, @yee} = config
      @votes = {}

    vote: (user, vote) ->
      @votes[user] = vote

    tally: ->
      tally = ""
      for user,vote of @votes
        tally += "#{user} voted #{vote}\n"
      return tally

  currentPoll = null

  getUser = (res) ->
    return res.message.user.name.toLowerCase()


  robot.hear /start ?vote ?(.*)/i, (res) ->
    title = res.match[1]
    currentPoll = new Poll({
      title: title
    })
    user = getUser(res)
    reply = "#{user} started a vote. vote with /placevote {{ your vote }}"
    res.send reply

  robot.hear /place ?vote (.*)/i, (res) ->
    if currentPoll
      currentPoll.vote getUser(res), res.match[1]
    else
      res.send "No poll currently"

  robot.hear /show ?vote/i, (res) ->
    if currentPoll
      reply =  "#{currentPoll.title}\n"
      reply += "Current votes:\n"
      reply += currentPoll.tally()

      res.send reply
    else
      res.send "No poll currently"

