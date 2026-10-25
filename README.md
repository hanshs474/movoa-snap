# Movoa snap

Unlimited AI video generator with sound: on paid plans the tenth take of a shot costs what the first did, and your first clip is free to make right now. This is the snap package of the official [Movoa](https://movoa.ai/?utm_source=snapcraft&utm_medium=package) CLI: type a prompt, get back the URL of the finished clip with its sound in the same file.

```
sudo snap install movoa
export MOVOA_API_KEY=sk-...   # from https://movoa.ai/settings/apikeys
movoa credits
movoa video "a paper boat drifting down a rain gutter, close-up"
movoa video "the camera slowly orbits the statue" --image https://example.com/statue.jpg
movoa video "a street drummer in the rain" --model seedance-2-5 --duration 10 --aspect-ratio 9:16
```

Runs cost credits on your Movoa account, at the prices on [movoa.ai/pricing](https://movoa.ai/pricing). On the web: [text to video](https://movoa.ai/video/text-to-video), [photo to video](https://movoa.ai/video/photo-to-video), [AI video with audio](https://movoa.ai/video/ai-video-with-audio), [Seedance 2.5](https://movoa.ai/video/seedance-2-5) and [Veo 3](https://movoa.ai/video/google-veo-3). Full command reference: [movoa-docker](https://github.com/hanshs474/movoa-docker).

`build.sh` cross-compiles the CLI from the [movoa-docker](https://github.com/hanshs474/movoa-docker) Go source for amd64 and arm64 and packs each into a `.snap` (no snapcraft or LXD needed); `upload.py` pushes and releases them to the stable channel with craft-store. MIT licensed.
