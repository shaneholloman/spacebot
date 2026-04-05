import { AppleLogo, AndroidLogo, Desktop, BookOpen, DiscordLogo } from "@phosphor-icons/react";
import { Card, CardHeader, CardContent, CardFooter, Button } from "@spacedrive/primitives";

const DOWNLOADS = [
	{ label: "macOS", icon: AppleLogo, href: "https://spacedrive.com/download" },
	{ label: "iOS", icon: AppleLogo, href: "https://spacedrive.com/download" },
	{ label: "Android", icon: AndroidLogo, href: "https://spacedrive.com/download" },
	{ label: "Windows", icon: Desktop, href: "https://spacedrive.com/download" },
] as const;

export function GetSpacedriveCard() {
	return (
		<Card>
			<CardHeader className="p-4 pb-2">
				<h2 className="font-plex text-sm font-medium text-ink-dull">Get Spacedrive</h2>
				<p className="text-tiny text-ink-faint">Your files, your agents, your data — on every device.</p>
			</CardHeader>

			<CardContent className="px-4 pb-0 pt-3">
				<div className="grid grid-cols-2 gap-2">
					{DOWNLOADS.map(({ label, icon: Icon, href }) => (
						<Button
							key={label}
							href={href}
							target="_blank"
							rel="noopener noreferrer"
							variant="default"
							size="sm"
							className="flex items-center gap-2"
						>
							<Icon className="h-3.5 w-3.5 shrink-0" />
							{label}
						</Button>
					))}
				</div>
			</CardContent>

			<CardFooter className="gap-2 px-4 pb-4 pt-3">
				<Button
					href="https://docs.spacedrive.com"
					target="_blank"
					rel="noopener noreferrer"
					variant="subtle"
					size="sm"
					className="flex flex-1 items-center justify-center gap-1.5"
				>
					<BookOpen className="h-3.5 w-3.5" />
					Docs
				</Button>
				<Button
					href="https://discord.gg/spacedrive"
					target="_blank"
					rel="noopener noreferrer"
					variant="subtle"
					size="sm"
					className="flex flex-1 items-center justify-center gap-1.5"
				>
					<DiscordLogo className="h-3.5 w-3.5" />
					Discord
				</Button>
			</CardFooter>
		</Card>
	);
}
